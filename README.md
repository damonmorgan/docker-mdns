# mDNS/Avahi Docker Image

Docker image for the Avahi mDNS/DNS-SD daemon. Connects to the system D-Bus, publishes the hostname and announces Traefik Host rules. Container requires network host, priveleged and access to the docker sock

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=mdns \
  -e SERVER_HOST_NAME=docker `#optional` \
  -e SERVER_DOMAIN_NAME=local `#optional` \
  -e NETWORK_INTERFACE=eth0 \
  -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
  -v /etc/dbus-1/system.d:/system-dbus \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --network host \
  --privileged \
  --restart unless-stopped \
  damonmorgan/traefik-mdns
```


### docker-compose

Compatible with docker-compose v3 schemas.

```
---
version: "3.8"
services:

#mDNS
  mdns:
    container_name: mdns
    image: damonmorgan/traefik-mdns
    environment:
      SERVER_HOST_NAME: 'docker'
      SERVER_DOMAIN_NAME: 'local'
      NETWORK_INTERFACE: 'enp2s0'
    volumes:
      - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
      - /etc/dbus-1/system.d:/system-dbus
      - /var/run/docker.sock:/var/run/docker.sock
    network_mode: "host"
    privileged: true
    restart: unless-stopped

#Reverse Proxy
  traefik:
    container_name: traefik
    image: traefik
    command:
      - "--api.insecure=true"
      - "--api.dashboard=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped

#Basic Web Service
  whoami:
    image: "containous/whoami"
    container_name: "simple-service"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.local`)"
      - "traefik.http.routers.whoami.entrypoints=web"
      - "traefik.http.services.whoami.loadbalancer.server.port=80"
```

## Credits
[https://github.com/flungo-docker/avahi](https://github.com/flungo-docker/avahi)

[https://github.com/cmsj/docker-avahi](https://github.com/cmsj/docker-avahi)

[https://github.com/ianblenke/docker-avahi](https://github.com/ianblenke/docker-avahi)

[https://gitlab.com/viraptor/docker_mdns](https://gitlab.com/viraptor/docker_mdns)

[linuxserverurl]: https://linuxserver.io
[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]
