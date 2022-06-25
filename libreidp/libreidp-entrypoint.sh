#!/bin/sh
###############################################################################
# NAME:             libreidp-entrypoint.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Entrypoint script for the container.
#
# CREATED:          06/12/2022
#
# LAST EDITED:      06/25/2022
###

# Generate the configuration file (used by default, unless the file path is
# overridden in the environment) based on the value of certain environment vars
cat - >$DEFAULT_CONFIGURATION_FILE <<EOF
ldap:
  uri: $LDAP_URI
  base: $LDAP_SEARCH_BASE
http:
  address: "0.0.0.0:$HTTP_PORT"
EOF

/bin/libreidp -c $CONFIGURATION_FILE

###############################################################################
