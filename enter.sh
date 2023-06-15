#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: [sudo] $0 <container> [command]..."
	exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
	exec sudo --preserve-env=USER "$0" "$@"
fi

if [ -z "$2" ]; then
	set -- "$@" bash
fi

if [ "$USER" = "root" ]; then
	# If this script was executed as root, enforce that in the container
	set -- -u root "$@"
fi

exec podman-compose exec "$@"
