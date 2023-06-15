#!/bin/sh -ex

if [ "$(id -u)" -eq 0 ]; then
	# Remove the socket if the parent container is restarted
	rm -f /var/run/docker.sock

	# Launch dockerd
	dockerd-entrypoint.sh &

	# Wait for dockerd to start
	while true; do
		if [ -S "/var/run/docker.sock" ]; then
			break
		fi

		sleep 1
	done

	# Let the entrypoint figure out the socket location
	unset DOCKER_HOST

	# Re-run this script with the entrypoint
	exec dockerd-entrypoint.sh su user -c "$0" "$@"
fi

# Prune old containers if the parent container is restarted
docker ps -aq | while IFS='' read -r container; do
	docker rm -f "$container"
done

# TODO: Only do this if building from source
docker buildx rm -f --all-inactive

# TODO: Only do this if building from source
docker buildx create \
	--driver docker-container \
	--driver-opt network=host \
	--name local1 \
	--buildkitd-flags '--allow-insecure-entitlement security.insecure' \
	--use

docker run -d -p 5005:5000 \
	--restart always \
	--name local registry:2

# Additional registry proxies
hack/start-registry-proxies.sh

docker run -d -p 5006:5000 \
    -e REGISTRY_PROXY_REMOTEURL=https://quay.io \
    --restart always \
    --name registry-quay.io registry:2

# Build the installer image
# TODO: Only do this if building from source
time make initramfs kernel installer IMAGE_REGISTRY=127.0.0.1:5005 PUSH=true TAG=v1.5.0-alpha.1

# Mark readiness
touch /tmp/ready
