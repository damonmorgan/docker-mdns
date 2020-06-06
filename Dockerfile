FROM crystallang/crystal:latest AS builder

RUN apt-get update && \
    apt-get install -y dbus libdbus-1-dev

RUN git clone https://gitlab.com/viraptor/docker_mdns.git

WORKDIR /docker_mdns
RUN shards build

FROM flungo/avahi
COPY --from=builder /docker_mdns/bin/docker_mdns /docker_mdns

ENTRYPOINT ["sh", "-c", "./docker_mdns $NETWORK_INTERFACE"]
