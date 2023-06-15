# Modprobe the required kernel modules for Talos networking on the host
FROM alpine:3

# BusyBox's modprobe doesn't support compressed modules
RUN apk --no-cache add kmod

ENTRYPOINT ["sh", "-xc"]
CMD ["modprobe -a sch_ingress cls_u32 act_mirred"]
