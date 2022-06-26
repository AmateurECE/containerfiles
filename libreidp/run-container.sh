#!/bin/sh
###############################################################################
# NAME:             run-container.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Start/stop containers necessary for this application.
#
# CREATED:          06/26/2022
#
# LAST EDITED:      06/26/2022
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error! This script must be run as root"
    exit 1
fi

export DOCKER_HOST=unix:///var/run/podman/podman.sock
CONTAINER_NAME=edtwardy-webservices_libreidp_1

((podman ps | grep $CONTAINER_NAME) && docker-compose restart) \
    || docker-compose up -d

###############################################################################
