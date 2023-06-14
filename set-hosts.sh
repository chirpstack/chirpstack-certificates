#!/usr/bin/env bash

set -e

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then 
	echo "Usage: $0 path/to/certificate.json host-one,host-two,host-three"
	exit 0
fi 

jq_hosts_command() {    
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

echo "Configuring '${1}' with hosts '${2}'"
COMMAND=$(jq_hosts_command "${2}")
contents=$(eval jq \'${COMMAND}\' ${1})
echo "${contents}" > ${1}