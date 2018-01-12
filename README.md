# LoRa Server certificates

This repository contains configuration to generate certificates for the
[LoRa Server](https://docs.loraserver.io/) project.

Note that the configuration in the examples can be substituted with the
related environment variables. E.g. the `--ca-cert` cli flag is equal to
the `CA_CERT` environment variable.

## Requirements

For generating the certificates, [cfssl](https://github.com/cloudflare/cfssl)
is being used. Make sure you have this tool installed.

## Generating certificates

Simply run `make` to generate all certificates. All certificates will be
written to the `certs` folder. See also the `Makefile` for all commands
being executed.

You probably want to make changes to the `certificate.json` files under
`config`. Please see [https://cfssl.org](https://cfssl.org) for documentation
about the `cfssl` usage.

## Certificates

### certs/ca

Use the `ca.pem` "common authority" certificate for every API endpoint you wish
to secure using TLS.

### certs/loraserver/api

These certificates are for securing the LoRa Server API which is by default
listening on port `8000` (see `--bind`).

#### server

These are the certificates for the server-side of the API. Configuration example:

```
--ca-cert  certs/ca/ca.pem
--tls-cert certs/loraserver/api/server/loraserver-api-server.pem
--tls-key  certs/loraserver/api/server/loraserver-api-server-key.pem
```

#### client

These are the client-side certificates (used by LoRa App Server) to connect to
the LoRa Server API.

**Important:** the `CN` of the client certificate must match the `--as-public-id`
of the LoRa App Server using the certificate.

When creating a [network-server](https://docs.loraserver.io/lora-app-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for LoRa App Server to LoRa Server connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/loraserver/api/client/loraserver-api-client.pem`
* **TLS key** content of `certs/loraserver/api/client/loraserver-api-client-key.pem`

### certs/lora-app-server/api

These certificates are for securing the LoRa App Server API which is by default
listening on port `8001` (see `--bind`). This is not the REST API!

#### server

These are the certificates for the server-side of the API. Configuration example:

```
--ca-cert  certs/ca/ca.pem
--tls-cert certs/lora-app-server/api/server/lora-app-server-api-server.pem
--tls-key  certs/lora-app-server/api/server/lora-app-server-api-server-key.pem
```

#### client

These are the client-side certificates (used by LoRa Server) to connect to the
LoRa App Server API.

**Important:** the `CN` of the client certificate must match the `--net-id`
of the LoRa Server instance using the certificate.

When creating a [network-server](https://docs.loraserver.io/lora-app-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for LoRa Server to LoRa App Server connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/lora-app-server/api/client/lora-app-server-api-client.pem`
* **TLS key** content of `certs/lora-app-server/api/client/lora-app-server-api-client-key.pem`
