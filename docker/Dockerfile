# Docker-in-Docker environment for running the cluster and hosting auxiliary containers. Rootful is about
# three times as fast as rootless when building Talos from source (20 min vs 1 h), so we'll use that for now.
FROM docker:dind

RUN apk --no-cache add bash make git nano

ARG _UID

RUN	adduser -Du "$_UID" user && \
	addgroup -S docker && \
	adduser user docker

USER docker

COPY launch.sh /

# Note: this must be launched with --init so it can be stopped with SIGTERM
CMD /launch.sh && sleep infinity
