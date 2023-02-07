#!/bin/sh

# -----------------------------------------------------------------------------
# Defaults
# -----------------------------------------------------------------------------

HOSTS=${HOSTS:-"127.0.0.1,localhost"}
echo "Configuring certificates"

# -----------------------------------------------------------------------------
# Modify certificate.json files
# -----------------------------------------------------------------------------

hosts_for_service() {

    local SERVICE=$1
    local HOSTS_FOR_SERVICE=$(eval echo \$$SERVICE)
    local HOSTS=${HOSTS_FOR_SERVICE:-$HOSTS}
    echo "$HOSTS"

}

command_from_hosts() {
    
    local HOSTS=$1

    local INDEX=0
    local COMMAND=".hosts=[]"
    local HOSTS_LIST=$(echo ${HOSTS} | sed -n 1'p' | tr ',' '\n')
    
    for HOST in ${HOSTS_LIST}
    do
        COMMAND="${COMMAND} | .hosts[${INDEX}]=\"${HOST}\""
        INDEX=$(( ${INDEX} + 1 ))
    done

    echo "$COMMAND"

}

for FOLDER in `find config -name server -type d`
do
    SERVICE=$(echo $FOLDER | sed 's/[-\/]/_/g' | tr 'a-z' 'A-Z' | sed 's/_SERVER$/_HOSTS/' | sed 's/^CONFIG_//'  | sed 's/^CHIRPSTACK_//')
    HOSTS_FOR_SERVICE=$(hosts_for_service "$SERVICE")
    COMMAND=$(command_from_hosts "$HOSTS_FOR_SERVICE")
    FILE=$FOLDER/certificate.json
    echo "Changing hosts in $FILE to \"$HOSTS_FOR_SERVICE\""
    contents=$(eval jq \'${COMMAND}\' $FILE)
    echo "${contents}" > $FILE
done
