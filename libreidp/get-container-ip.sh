#!/bin/sh
###############################################################################
# NAME:             get-container-ip.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Get the IP of the container.
#
# CREATED:          06/13/2022
#
# LAST EDITED:      06/26/2022
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error: This script must be run as root!"
    exit 1
fi

CONTAINER_NAME=edtwardy-webservices_libreidp_1
NETWORK_NAME=edtwardy-webservices_front_net
IP_QUERY="{{(index .NetworkSettings.Networks \"$NETWORK_NAME\").IPAddress}}"

podman inspect -f "IPv4: $IP_QUERY" $CONTAINER_NAME

###############################################################################
