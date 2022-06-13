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
# LAST EDITED:      06/13/2022
###

if [ "0" != $(id -u) ]; then
    >&2 printf '%s\n' "Error: This script must be run as root!"
    exit 1
fi

podman run -d --name edtwardy-webservices_libreidp_1 \
       --network edtwardy-webservices_front_net \
       -e LDAP_URI=ldap://edtwardy-webservices_openldap_1 \
       docker.io/edtwardy/libreidp:latest

###############################################################################
