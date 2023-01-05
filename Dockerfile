FROM --platform=$BUILDPLATFORM alpine:3.17.0
ARG BUILDPLATFORM

# Install dependencies
RUN apk add --no-cache bash make curl jq

# Install cfssl and cfssljson
RUN case "$BUILDPLATFORM" in \
	"linux/amd64") \
        curl -sL https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssl_linux-amd64 --output /bin/cfssl; \
        curl -sL https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssljson_linux-amd64 --output /bin/cfssljson; \
		;; \
	"linux/arm/v7"|"linux/arm64") \
        curl -sL https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssl_linux-arm --output /bin/cfssl; \
        curl -sL https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssljson_linux-arm --output /bin/cfssljson; \
		;; \
	esac; \
    chmod +x /bin/cfssl* ;

# Set workdir to the root of the repository working copy
WORKDIR /opt/chirpstack-certificates

# Add entry point script
ADD config ./config
ADD Makefile entrypoint.sh .
RUN chmod +x *.sh

# Launch the script on container startup
CMD ["bash", "entrypoint.sh"]
