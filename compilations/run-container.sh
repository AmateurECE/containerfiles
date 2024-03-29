#!/bin/sh
###############################################################################
# NAME:             run-container.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Execute a container of this image for development
#
# CREATED:          06/13/2022
#
# LAST EDITED:      01/11/2023
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error: This script must be run as root!"
    exit 1
fi

CONTAINER_NAME=twardyece_compilations_1

# Bring down the container if it's running
(podman ps | grep $CONTAINER_NAME) && podman stop $CONTAINER_NAME \
    && podman rm $CONTAINER_NAME

# Restart it
podman run -d --name $CONTAINER_NAME \
     --network edtwardy-webservices_front_net \
     -v compilations-secret:/data:ro \
     -e TZ=America/Chicago \
     docker.io/edtwardy/compilations:latest

# Need to restart Nginx
podman restart twardyece_nginx_1

###############################################################################
