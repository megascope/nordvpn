# Nordvpn Docker Routing Container

Create a nordvpn container, using the instructions from xxx for use with docker.

Example `docker-compose.yml`

```
services:
  nordvpn:
    image: ghcr.io/megascope/nordvpn
    container_name: nordvpn-active
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=1  # Recomended if using ipv4 only

    volumes:
      - "nordvpn-data:/var/lib/nordvpn"

volumes:
    nordvpn-data:

```

Once the you have pulled the image, you will need to configure nordvpn. Start the service using `docker compose up -d` then login

```
docker exec -it nordvpn-active bash
root@12345dsfd:/# nordvpn login

# <paste link in browser, then copy URL of callback button> #

root@12345dsfd:/# nordvpn login --callback <url pasted from button>

# you can also edit various nordvpn settings, like turning on the killswitch

root@12345dsfd:/# nordvpn set killswitch on
```

All settings are stored in the volume, so will persist between container restarts.

## Using with Other Containers

To use with another container, assign it to this containers namespace, e.g.

```
    network_mode: container:nordvpn-active
```

in the docker compose, or from the command line
```
docker run --rm --network=container:nordvpn -it jonlabelle/network-tools
```
