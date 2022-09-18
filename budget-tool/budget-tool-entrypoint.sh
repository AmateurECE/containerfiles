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

# Run the migrations first
/bin/budget-migrations -s $SECRET_FILE

# Start the service
/bin/budget-service -s $SECRET_FILE

###############################################################################
