# Running

TFTP is a multi-port protocol, so the best way to expose this service is to use
host networking mode:

```bash-session
$ podman run \
    -it \
    --name tftp \
    --rm \
    --network=host \
    -v ./directory:/tftp:ro \
    amateurece/tftp-hpa:latest
```
