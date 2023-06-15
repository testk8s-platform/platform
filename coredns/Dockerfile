# CoreDNS server for the cluster for resolving external artifacts
FROM alpine:3

RUN apk --no-cache add coredns
COPY Corefile /

ENTRYPOINT ["coredns"]
