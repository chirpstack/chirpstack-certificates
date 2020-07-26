make: certs/ca certs/chirpstack-network-server/api certs/chirpstack-application-server/api certs/chirpstack-gateway-bridge/basicstation

docker:
	docker run --rm cfssl make

clean:
	rm -rf certs

certs/ca:
	mkdir -p certs/ca
	cfssl gencert -initca config/ca-csr.json | cfssljson -bare certs/ca/ca

certs/chirpstack-network-server/api: certs/ca
	mkdir -p certs/chirpstack-network-server/api/server
	mkdir -p certs/chirpstack-network-server/api/client

	# chirpstack-network-server api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/chirpstack-network-server/api/server/certificate.json | cfssljson -bare certs/chirpstack-network-server/api/server/chirpstack-network-server-api-server

	# chirpstack-network-server api client certificate (e.g. for chirpstack-application-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/chirpstack-network-server/api/client/certificate.json | cfssljson -bare certs/chirpstack-network-server/api/client/chirpstack-network-server-api-client

certs/chirpstack-application-server/api: certs/ca
	mkdir -p certs/chirpstack-application-server/api/server
	mkdir -p certs/chirpstack-application-server/api/client
	mkdir -p certs/chirpstack-application-server/join-api/server
	mkdir -p certs/chirpstack-application-server/join-api/client

	# chirpstack-application-server api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/chirpstack-application-server/api/server/certificate.json | cfssljson -bare certs/chirpstack-application-server/api/server/chirpstack-application-server-api-server

	# chirpstack-application-server api client certificate (e.g. for chirpstack-network-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/chirpstack-application-server/api/client/certificate.json | cfssljson -bare certs/chirpstack-application-server/api/client/chirpstack-application-server-api-client

	# chirpstack-application-server join api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/chirpstack-application-server/join-api/server/certificate.json | cfssljson -bare certs/chirpstack-application-server/join-api/server/chirpstack-application-server-join-api-server

	# chirpstack-application-server join api client certificate (e.g. for chirpstack-network-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/chirpstack-application-server/join-api/client/certificate.json | cfssljson -bare certs/chirpstack-application-server/join-api/client/chirpstack-application-server-join-api-client

certs/chirpstack-gateway-bridge/basicstation: certs/ca
	mkdir -p certs/chirpstack-gateway-bridge/basicstation/server
	mkdir -p certs/chirpstack-gateway-bridge/basicstation/client

	# basicstation websocket server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/chirpstack-gateway-bridge/basicstation/server/certificate.json | cfssljson -bare certs/chirpstack-gateway-bridge/basicstation/server/basicstation-server

	# basicstation websocket client (gateway) certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/chirpstack-gateway-bridge/basicstation/client/certificate.json | cfssljson -bare certs/chirpstack-gateway-bridge/basicstation/client/basicstation-client

