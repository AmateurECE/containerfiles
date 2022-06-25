#!/bin/sh
###############################################################################
# NAME:             run-container.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Run a container of this image for development.
#
# CREATED:          06/13/2022
#
# LAST EDITED:      06/25/2022
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error: This script must be run as root!"
    exit 1
fi

CONTAINER_NAME=edtwardy-webservices_libreidp_1
NETWORK_NAME=edtwardy-webservices_front_net
IP_QUERY="{{(index .NetworkSettings.Networks \"$NETWORK_NAME\").IPAddress}}"

# Bring down the container if it's running
(podman ps | grep $CONTAINER_NAME) && podman stop $CONTAINER_NAME

podman run -d --rm --name $CONTAINER_NAME --network $NETWORK_NAME \
       -e LDAP_URI="ldap://edtwardy-webservices_openldap_1" \
       -e LDAP_SEARCH_BASE="ou=people,dc=edtwardy,dc=hopto,dc=org" \
       docker.io/edtwardy/libreidp:latest

podman inspect -f "IPv4: $IP_QUERY" $CONTAINER_NAME

###############################################################################
