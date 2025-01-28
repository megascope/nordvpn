# from https://support.nordvpn.com/hc/en-us/articles/20465811527057-How-to-build-the-NordVPN-Docker-image
# sudo docker run -it --hostname mycontainer --cap-add=NET_ADMIN --sysctl net.ipv6.conf.all.disable_ipv6=0 <image name>
# nordvpn stores logins and other data in /var/lib/nordvpn
FROM ubuntu:24.04

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates && \
    apt-get install -y curl iputils-ping netcat-traditional traceroute socat

RUN wget -qO /etc/apt/trusted.gpg.d/nordvpn_public.asc https://repo.nordvpn.com/gpg/nordvpn_public.asc && \
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nordvpn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c", "/etc/init.d/nordvpn start && sleep 5 && exec \"$0\" \"$@\"", "--"]
CMD ["/bin/tail", "-f", "/var/log/nordvpn/daemon.log"]
