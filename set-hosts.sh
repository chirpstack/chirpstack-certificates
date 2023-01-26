#!/bin/sh

# -----------------------------------------------------------------------------
# Defaults
# -----------------------------------------------------------------------------

HOSTS=${HOSTS:-"127.0.0.1,localhost"}
echo "Configuring certificates for $HOSTS"

# -----------------------------------------------------------------------------
# Modify certificate.json files
# -----------------------------------------------------------------------------

INDEX=0
COMMAND=".hosts=[]"
HOSTS_LIST=$(echo ${HOSTS} | sed -n 1'p' | tr ',' '\n')
for HOST in ${HOSTS_LIST}
do
    COMMAND="${COMMAND} | .hosts[${INDEX}]=\"${HOST}\""
    INDEX=$(( ${INDEX} + 1 ))
done

for FOLDER in `find config -name server -type d`
do
    contents=$(eval jq \'${COMMAND}\' $FOLDER/certificate.json)
    echo "${contents}" > $FOLDER/certificate.json
done
