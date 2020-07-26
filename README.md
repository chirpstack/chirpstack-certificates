# ChirpStack certificates

This repository contains configuration to generate certificates for the
[ChirpStack](https://www.chirpstack.io/) project.

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

### certs/chirpstack/api

These certificates are for securing the ChirpStack API which is by default
listening on port `8000` (see `chirpstack-network-server.toml` configuration file).

#### server

These are the certificates for the server-side of the API and must be
configured in `chirpstack-network-server.toml`. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/chirpstack-network-server/api/server/chirpstack-network-server-api-server.pem"
tls_key="certs/chirpstack-network-server/api/server/chirpstack-network-server-api-server-key.pem"
```

#### client

These are the client-side certificates (used by ChirpStack Application Server) to connect to
the ChirpStack API.

**Important:** the `CN` of the client certificate must match the `as_public_id`
of the ChirpStack Application Server instance (see `chirpstack-application-server.toml` configuration file)
using the generated certificate.

When creating a [Network server](https://www.chirpstack.io/application-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for ChirpStack Application Server to ChirpStack connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/chirpstack-network-server/api/client/chirpstack-network-server-api-client.pem`
* **TLS key** content of `certs/chirpstack-network-server/api/client/chirpstack-network-server-api-client-key.pem`

### certs/chirpstack-application-server/api

These certificates are for securing the ChirpStack Application Server API which is by default
listening on port `8001` (see `chirpstack-application-server.toml`). This is not the REST API!

#### server

These are the certificates for the server-side of the API and must be configured
in `chirpstack-application-server.toml`. Example:

```toml
ca_cert="certs/ca/ca.pem"
tls_cert="certs/chirpstack-application-server/api/server/chirpstack-application-server-api-server.pem"
tls_key="certs/chirpstack-application-server/api/server/chirpstack-application-server-api-server-key.pem"
```

#### client

These are the client-side certificates (used by ChirpStack) to connect to the
ChirpStack Application Server API.

**Important:** the `CN` of the client certificate must match the `net_id`
of the ChirpStack instance using the certificate (see `chirpstack-network-server.toml`).

When creating a [Network server](https://www.chirpstack.io/application-server/use/network-servers/)
using the web-interface, you must enter the content of the following
files under *Certificates for ChirpStack to ChirpStack Application Server connection*:

* **CA certificate** content of `certs/ca/ca.pem`
* **TLS certificate** content of `certs/chirpstack-application-server/api/client/chirpstack-application-server-api-client.pem`
* **TLS key** content of `certs/chirpstack-application-server/api/client/chirpstack-application-server-api-client-key.pem`

### certs/chirpstack-application-server/join-api

These certificates are for securing the ChirpStack Application Server Join API which is by
default listening on port `8003` (see `chirpstack-application-server.toml`).

#### server

These are the certificates for the server-side of the Join API and must be
configured in `chirpstack-application-server.toml`. Example:

```toml
js_ca_cert="certs/ca/ca.pem"
js_tls_cert="certs/chirpstack-application-server/join-api/server/chirpstack-application-server-join-api-server.pem"
js_tls_key="certs/chirpstack-application-server/join-api/server/chirpstack-application-server-join-api-server-key.pem"
```

#### client

**Important:** the `CN` of the client certificate must match the `net_id`
of the ChirpStack instance using the certificate (see `chirpstack-network-server.toml`).

These are the client-side certificates (used by ChirpStack) to connect to the ChirpStack
Join API and must be configured in `chirpstack-network-server.toml`. Example:

```toml
js_ca_cert="certs/ca/ca.pem"
js_tls_cert="certs/chirpstack-application-server/join-api/client/chirpstack-application-server-join-api-client.pem"
js_tls_key="certs/chirpstack-application-server/join-api/client/chirpstack-application-server-join-api-client-key.pem"
```
