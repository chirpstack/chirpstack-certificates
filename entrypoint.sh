#!/bin/sh

# -----------------------------------------------------------------------------
# Defaults
# -----------------------------------------------------------------------------

HOSTS=${HOSTS:-"127.0.0.1,localhost"}

# -----------------------------------------------------------------------------
# Check cache
# Avoid recreating the certificates unless the HOSTS variables changes
# -----------------------------------------------------------------------------

CACHE_FILE="certs/.cache"
CACHED_HOSTS=$([ -f $CACHE_FILE ] && cat $CACHE_FILE)
if [[ "$CACHED_HOSTS" == "$HOSTS" ]]; then
    echo "Using cached certificates for $HOSTS, quitting"
    exit 0
fi

# -----------------------------------------------------------------------------
# Create the certificates
# -----------------------------------------------------------------------------
HOSTS=$HOSTS make set-hosts
make clean
make
if [ $? -eq 0 ]; then
    echo "$HOSTS" > $CACHE_FILE
fi

# -----------------------------------------------------------------------------
# Bridge service needs them chmod'd
# -----------------------------------------------------------------------------
chmod 777 -R certs

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
echo "Certificates are ready, quitting"
exit 0
