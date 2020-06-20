FROM crystallang/crystal:latest AS builder

RUN apt-get update && \
    apt-get install -y libdbus-1-dev

RUN git clone https://gitlab.com/damon.morgan/docker_mdns.git

WORKDIR /docker_mdns
RUN shards build

RUN ldd /docker_mdns/bin/docker_mdns | tr -s '[:blank:]' '\n' | grep '^/' | \
   xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

FROM lsiobase/alpine

RUN apk add --update --no-cache \
      avahi \
      augeas

COPY --from=builder /docker_mdns/deps /
COPY --from=builder /docker_mdns/bin/docker_mdns /usr/local/bin/docker_mdns
COPY root/ /
