# testk8s Platform

Immutable, reproducible VM-based Talos Linux platform of `testk8s-platform`.

## Requirements

- `docker` and `docker compose`, or `podman` and `podman-compose`
  - Rootful, since `SYS_ADMIN` and `NET_ADMIN` are needed
  - `--privileged` is only required for the (optional) `modprobe` container
- KVM support on the host (check with `ls /dev/kvm`)
- A POSIX compliant shell for supporting scripts

Kernel modules needed for networking on the host (will be `modprobe`d automatically):

- `act_mirred`
- `cls_u32`
- `sch_ingress`

## Configuration

See the [`.env` file](.env) for configuration options and their explanations.

## Usage

Start up the platform with `sudo docker compose up` or `sudo podman-compose up`. This should build download/build all needed components automatically and start the Talos Linux cluster in the `talos` container.

Use `./enter.sh talos` to enter the `talos` container. The runtime environment should set itself up automatically, but the following tools are available for debugging and manual deployment:

- `kubectl`
- `k9s`

## Debugging Issues

### VMs not starting

- Inside the `talos` container, first check the logs of the first control plane VM, which often contain helpful hints about the issue:

  ```sh
  tail -f ~/.talos/clusters/talos-default/talos-default-controlplane-1.log
  ```
- If there is an error related to networking, check that the `modprobe` container has executed successfully with `docker compose logs modprobe` or `podman-compose logs modprobe`.
- If there is a networking error despite all the kernel modules from the [requirements](#requirements) being loaded, try to re-create the `talos container` with `docker compose up -d --force-recreate talos` or `podman-compose up -d --force-recreate talos`.

### Various permission errors

- Check that you are running `docker compose` or `podman-compose` with sufficient privileges
- Ensure that `/dev/kvm` is present and has the right permissions

## Authors

- Dennis Marttinen ([@twelho](https://github.com/twelho))

## Credits

`testk8s-platform` has been developed with support from the [Secure Systems Group](https://ssg.aalto.fi/) of the [Department of Computer Science](https://www.aalto.fi/en/department-of-computer-science?redirectFrom=department-of-computer-science) at [Aalto University](http://www.aalto.fi/en/), Espoo, Finland.

## License

[MPL-2.0](https://opensource.org/license/mpl-2-0/) ([LICENSE](LICENSE))
