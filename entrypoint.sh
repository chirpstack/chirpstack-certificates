#!/bin/bash

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

HOSTS=${HOSTS:-"127.0.0.1,localhost"}
CACHE_FILE="certs/.cache"

# -----------------------------------------------------------------------------
# Check cache
# -----------------------------------------------------------------------------

CACHED_HOSTS=$([ -f $CACHE_FILE ] && cat $CACHE_FILE)
if [[ "$CACHED_HOSTS" == "$HOSTS" ]]; then
    echo "Using cached certificates, quitting"
    exit 0
fi

# -----------------------------------------------------------------------------
# Edit cfssl configuration
# -----------------------------------------------------------------------------

INDEX=0
COMMAND=".hosts=[]"
IFS=',' read -ra HOSTS_LIST <<< "$HOSTS"
for HOST in "${HOSTS_LIST[@]}"
do
    COMMAND="${COMMAND} | .hosts[$INDEX]=\"$HOST\""
    INDEX=$(( $INDEX + 1 ))
done
COMMAND="jq '"$COMMAND"' certificate.json"

for FOLDER in `find config -name server -type d`
do
    pushd $FOLDER >> /dev/null
    contents=$(eval ${COMMAND})
    echo -E "${contents}" > certificate.json
    popd >> /dev/null
done

# -----------------------------------------------------------------------------
# Create the certificates
# -----------------------------------------------------------------------------
make clean
make
if [[ $? -eq 0 ]]; then
    echo "$HOSTS" > $CACHE_FILE
fi

# -----------------------------------------------------------------------------
# Bridge service needs them chmod'd 666
# -----------------------------------------------------------------------------
chmod 666 -R certs
chmod a+X -R certs

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
echo "Certificates are ready, quitting"
exit 0
