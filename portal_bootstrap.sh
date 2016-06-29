#!/bin/bash -e


#####################
# Utility functions #
#####################

# Prints a message and exits with a non-zero code.
function die {
    echo $*
    exit 1
}

###############
# Main script #
###############

if [ -z "$MODE" ] || [ -z "$USERID" ] || [ -z "$GROUPID" ]
then
    echo "usage: portal_bootstrap.sh with the following environment variables"
    echo
    echo "MODE:"
    echo "     development: starts the application in Rails development mode."
    echo "     test:        starts the application in Rails test mode."
    echo "     production:  starts the application in Rails production mode."
    echo 
    echo "USERID: ID of the user that will run the CBRAIN portal."
    echo
    echo "GROUPID: group ID of the user that will run the CBRAIN portal."
    exit 1
fi

groupmod -g ${GROUPID} cbrain || die "groupmod -g ${GROUPID} cbrain failed"
usermod -u ${USERID} cbrain  || die "usermod -u ${USERID} cbrain" # the files in /home/cbrain are updated automatically
VOLUMES="/home/cbrain/cbrain_data_cache \
                  /home/cbrain/.ssh \
                  /home/cbrain/plugins \
                  /home/cbrain/data_provider"
# This folder may not be always mounted
[ -d /home/cbrain/.bourreau_ssh ] && VOLUMES="$VOLUMES /home/cbrain/.bourreau_ssh"
for volume in $VOLUMES
do
    echo "chowning ${volume}"
    chown cbrain:cbrain ${volume}
done
exec su cbrain "/home/cbrain/cbrain/Docker/portal.sh"