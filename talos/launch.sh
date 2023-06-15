#!/bin/sh -ex

# Remove any previous cluster configuration if existing container is restarted
rm -rf ~/.talos/clusters/talos-default

# Define talosctl options
# TODO: Only do mirroring of 127.0.0.1:5005 and overriding install image if building locally
# TODO: Enable configuration of the Talos CIDR
set -- \
	--provisioner=qemu \
	--cidr=172.20.0.0/24 \
	--registry-mirror docker.io=http://docker:5000 \
	--registry-mirror registry.k8s.io=http://docker:5001 \
	--registry-mirror gcr.io=http://docker:5003 \
	--registry-mirror ghcr.io=http://docker:5004 \
	--registry-mirror quay.io=http://docker:5006 \
	--registry-mirror 127.0.0.1:5005=http://docker:5005 \
	--install-image=127.0.0.1:5005/siderolabs/installer:v1.5.0-alpha.1 \
	--controlplanes 1 \
	--workers 2 \
	--with-bootloader=false \
	--with-cluster-discovery=false \
	--nameservers 172.30.0.100 \
	--disk 16384 \
	--wait-timeout 60m

# Source configuration patches
for patch in /patch/*.yaml; do
    set -- "$@" --config-patch "@$patch"
done

# Create the cluster
exec talosctl cluster create "$@"
