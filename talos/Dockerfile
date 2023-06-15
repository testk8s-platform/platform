# TODO: Set tag to "3" once kubectl lands there
FROM alpine:edge

# Install base dependencies
RUN apk --no-cache add iptables ip6tables ovmf qemu-system-x86_64

# Install tooling and helpers
RUN apk --no-cache add bash bash-completion kubectl k9s

# Fix ip{,6}tables to point to ip{,6}tables-nft, since the legacy
# iptables will not work in a container without --privileged
RUN	mkdir -p /usr/local/sbin && \
	ln -s /sbin/iptables-nft /usr/local/sbin/iptables && \
	ln -s /sbin/ip6tables-nft /usr/local/sbin/ip6tables

# TODO: Only do this if building from scratch is enabled
# TODO: This can be dynamically detected in launch.sh
RUN ln -s /talos/_out/talosctl-linux-amd64 /usr/local/bin/talosctl

COPY launch.sh /
COPY patch /patch

# Note: this must be launched with --init so it can be stopped with SIGTERM
CMD /launch.sh && sleep infinity
