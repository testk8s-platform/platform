# Generate and host manifests for platform software
FROM alpine:3

RUN apk --no-cache add helm python3

COPY config /config

# TODO: Support Cilium version configurability
# TODO: Enable configuration of k8sServiceHost (and the Talos CIDR)
RUN	helm repo add cilium https://helm.cilium.io/ && \
	helm repo update && \
	helm template \
		cilium \
		cilium/cilium \
		--version 1.13.0 \
		--namespace kube-system \
		--set prometheus.enabled=true \
		--set operator.prometheus.enabled=true \
		--set hubble.enabled=true \
		--set hubble.metrics.enableOpenMetrics=true \
		--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}" \
		--set ipam.mode=kubernetes \
		--set=kubeProxyReplacement=strict \
		--set=securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
		--set=securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
		--set=cgroup.autoMount.enabled=false \
		--set=cgroup.hostRoot=/sys/fs/cgroup \
		--set=k8sServiceHost="172.20.0.1" \
		--set=k8sServicePort=6443 > /config/cilium.yaml

CMD python -m http.server -d /config 80
