#!/bin/sh -e

exec avahi-daemon "$@"

docker_mdns "$NETWORK_INTERFACE"
