#!/bin/sh
###############################################################################
# NAME:             compilations-entrypoint.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Entrypoint script for the compilations container.
#
# CREATED:          06/04/2022
#
# LAST EDITED:      06/11/2022
###

# Start the application server
/bin/compilations -s "$SECRET_FILE" -c "$CONF_FILE"

###############################################################################
