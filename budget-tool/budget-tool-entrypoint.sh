#!/bin/sh
###############################################################################
# NAME:             budget-tool-entrypoint.sh
#
# AUTHOR:           Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:      Entrypoint for the budget-tool container.
#
# CREATED:          09/18/2022
#
# LAST EDITED:      09/18/2022
###

export DATABASE_URL
set -e

printf '%s\n' "Running migrations"
/bin/budget-migrations -s $SECRET_FILE

printf '%s\n' "Starting budget-service"
/bin/budget-service -s $SECRET_FILE

###############################################################################
