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
# LAST EDITED:      06/26/2022
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error: This script must be run as root!"
    exit 1
fi

CONTAINER_NAME=edtwardy-webservices_compilations_1

# Bring down the container if it's running
(podman ps | grep $CONTAINER_NAME) && podman stop $CONTAINER_NAME

# Restart it
podman run -d --rm --name $CONTAINER_NAME \
     --network edtwardy-webservices_front_net \
     -v compilations-secret:/data:ro \
     -e TZ=America/Chicago \
     docker.io/edtwardy/compilations:latest

# Need to restart Nginx
podman restart edtwardy-webservices_nginx_1

###############################################################################
