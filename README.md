# LoRa Server certificates

This repository contains configuration to generate certificates for the
[LoRa Server](https://www.loraserver.io/) project.

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
listening on port `8000` (see `loraserver.toml` configuration file).

#### server

These are the certificates for the server-side of the API and must be
configured in `loraserver.toml`. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/loraserver/api/server/loraserver-api-server.pem"
tls_key="certs/loraserver/api/server/loraserver-api-server-key.pem"
```

#### client

These are the client-side certificates (used by LoRa App Server) to connect to
the LoRa Server API.

**Important:** the `CN` of the client certificate must match the `as_public_id`
of the LoRa App Server instance (see `lora-app-server.toml` configuration file)
using the generated certificate.

When creating a [network-server](https://docs.loraserver.io/lora-app-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for LoRa App Server to LoRa Server connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/loraserver/api/client/loraserver-api-client.pem`
* **TLS key** content of `certs/loraserver/api/client/loraserver-api-client-key.pem`

### certs/lora-app-server/api

These certificates are for securing the LoRa App Server API which is by default
listening on port `8001` (see `lora-app-server.toml`). This is not the REST API!

#### server

These are the certificates for the server-side of the API and must be configured
in `lora-app-server.toml`. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/lora-app-server/api/server/lora-app-server-api-server.pem"
tls_key="certs/lora-app-server/api/server/lora-app-server-api-server-key.pem"
```

#### client

These are the client-side certificates (used by LoRa Server) to connect to the
LoRa App Server API.

**Important:** the `CN` of the client certificate must match the `net_id`
of the LoRa Server instance using the certificate (see `loraserver.toml`).

When creating a [network-server](https://docs.loraserver.io/lora-app-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for LoRa Server to LoRa App Server connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/lora-app-server/api/client/lora-app-server-api-client.pem`
* **TLS key** content of `certs/lora-app-server/api/client/lora-app-server-api-client-key.pem`

### certs/lora-app-server/join-api

These certificates are for securing the LoRa App Server Join API which is by
default listening on port `8003` (see `lora-app-server.toml`).

#### server

These are the certificates for the server-side of the Join API and must be
configured in `lora-app-server.toml`. Example:

```toml
js_ca_cert="certs/ca/ca.pem"
js_tls_cert="certs/lora-app-server/join-api/server/lora-app-server-join-api-server.pem"
js_tls_key="certs/lora-app-server/join-api/server/lora-app-server-join-api-server-key.pem"
```

#### client

**Important:** the `CN` of the client certificate must match the `net_id`
of the LoRa Server instance using the certificate (see `loraserver.toml`).

These are the client-side certificates (used by LoRa Server) to connect to the LoRa Server
Join API and must be configured in `loraserver.toml`. Example:

```toml
js_ca_cert="certs/ca/ca.pem"
js_tls_cert="certs/lora-app-server/join-api/client/lora-app-server-join-api-client.pem"
js_tls_key="certs/lora-app-server/join-api/client/lora-app-server-join-api-client-key.pem"
```

### certs/lora-geo-server/api

These certificates are for securing the LoRa Geo Server API which is by default
listening on port `8005` (see `lora-geo-server.toml`).

#### server

These are the certificates for the server-side of the API and must be
configured in the `lora-geo-server.toml` configuration file. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/lora-geo-server/api/server/lora-geo-server-api-server.pem"
tls_key="certs/lora-geo-server/api/server/lora-geo-server-api-server-key.pem"
```

#### client

These are the client-side certificates (used by LoRa Server) to connect to the
LoRa Geo Server API and must be configured in `loraserver.toml`. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/lora-geo-server/api/client/lora-geo-server-api-client.pem"
tls_key="certs/lora-geo-server/api/client/lora-geo-server-api-client-key.pem"
```
