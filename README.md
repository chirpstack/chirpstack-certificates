# ChirpStack certificates

This repository contains configuration to generate certificates that can be
used by [ChirpStack](https://www.chirpstack.io/) for securing gateway
connections and the per-application MQTT integration connections:

* Generating a "common authority" for
  * Signing (client-)certificates
  * Validating (client-)certificates
* Server-certificate for the ChirpStack Gateway Bridge to use mTLS if configured with the Basics Station backend
* Server-certificate for the MQTT broker to allow mTLS based authentication and authorization for
  * Gateways connecting over MQTT (certificate per Gateway ID)
  * Per-application MQTT integrations (certificate per Application ID)

## Requirements

For generating the certificates, [cfssl](https://github.com/cloudflare/cfssl)
is used. Make sure you have this tool installed.

To modify the hosts using the `set-hosts` command you will need
[jq](https://stedolan.github.io/jq/) installed.

## Modifying hosts

You can modify all `certificate.json` files at once with specific hosts with the
`make set-hosts` command:

```
MQTT_BROKER_HOSTS=127.0.0.1,localhost,mqtt.example.com \
CHIRPSTACK_GATEWAY_BRIDGE_HOSTS=127.0.0.1,localhost,cgwb.example.com \
make set-hosts
```

The `make set-hosts` accepts the following environment variables:

* `MQTT_BROKER_HOSTS`: comma-separated list of hostnames for the MQTT broker
* `CHIRPSTACK_GATEWAY_BRIDGE_HOSTS`: comma-separated list of hostnames for the ChirpStack Gateway Bridge (Basics Station backend)

In case the environment variable is not specified, then it will fallback to
`127.0.0.1,localhost`.

## Modifying hosts using Docker Compose

Using Docker Compose, you can use the following command:

```
docker-compose run --rm \
    -e MQTT_BROKER_HOSTS="localhost,mqtt.example.com" \
    -e CHIRPSTACK_GATEWAY_BRIDGE_HOSTS="localhost,cgwb.example.com" \
    chirpstack-certificates make set-hosts
```

## Generating certificates

Simply run `make` to generate all certificates. All certificates will be
written to the `certs` folder. See also the `Makefile` for all commands
being executed.

You probably want to make changes to the `certificate.json` files under
`config`. Please see [https://cfssl.org](https://cfssl.org) for documentation
about the `cfssl` usage.

## Generating certificates using Docker Compose

An alternate way to generate the certificates that does not require to have the
different dependencies installed is by using docker (you will need docker, of course).

```
docker-compose run --rm chirpstack-certificates make
```

## Certificates

### certs/ca

This directory contains the CA certificate and private key that you must configure
in the `chirpstack.toml` configuration, such that it can generate
client-certificates for gateways and application integrations. 

The CA certificate must also be configured in the MQTT broker and by the
ChirpStack Gateway Bridge Basics Station backend (if used) to validate the
client-certificate of connecting clients.

### certs/chirpstack-gateway-bridge/basicstation

This directory contains the server-certificate and private key used by the
ChirpStack Gateway Bridge Basics Station backend (if used). 

### certs/mqtt-broker

This directory contains the server-certificate and private key used by the
MQTT broker.

## Configuration examples

Note that the filenames in the example refer to the filenames as being used
in the `certs/` directory (not including the names of the directories).

The examples assume that you will copy the generated certificates to the
appropriate directories, and that you will set the correct file-permissions.

### ChirpStack

To enable creating client-certificates for gateways through the web-interface,
you must configure the `[gateway]` section in the `chirpstack.toml`
configuration:

```toml
[gateway]
client_cert_lifetime="12months"
ca_cert="/etc/chirpstack/certs/ca.pem"
ca_key="/etc/chirpstack/certs/ca-key.pem"
```

To enable creating client-certificates for (per application) MQTT integrations,
you must configure the `[integration.mqtt.client]` section in the
`chirpstack.toml` configuration:

```toml
[integration.mqtt.client]
client_cert_lifetime="12months"
ca_cert="/etc/chirpstack/certs/ca.pem"
ca_key="/etc/chirpstack/certs/ca-key.pem"
```

### ChirpStack Gateway Bridge

To enable TLS and validating gateway client-certificates of incoming
Basics Station connections, you must configure the
`[backend.basicstation]` section in the `chirpstack-gateway-bridge.toml`
configuration:

```toml
[backend.basic_station]
tls_cert="/etc/chirpstack-gateway-bridge/certs/basicstation.pem"
tls_key="/etc/chirpstack-gateway-bridge/certs/basicstation-key.pem"
ca_cert="/etc/chirpstack-gateway-bridge/certs/ca.pem"
```

### Mosquitto

To enable TLS and validating client-certificates of incoming MQTT connections
(gateways and per-application MQTT integrations), you must configure a TLS
listener. Example:

`/etc/mosquitto/acl`:

```
pattern readwrite +/gateway/%u/#
pattern readwrite application/%u/#
```

`/etc/mosquitto/conf.d/listeners.conf`:

```
per_listener_settings true

listener 1883 127.0.0.1
allow_anonymous true

listener 8883 0.0.0.0
cafile /etc/mosquitto/certs/ca.pem
certfile /etc/mosquitto/certs/mqtt-broker.pem
keyfile /etc/mosquitto/certs/mqtt-broker-key.pem
allow_anonymous false
require_certificate true
use_identity_as_username true
acl_file /etc/mosquitto/acl
```

For more information, please refer to the [Mosquitto TLS configuration guide](https://www.chirpstack.io/docs/guides/mosquitto-tls-configuration.html).