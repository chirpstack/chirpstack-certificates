make: certs/ca certs/chirpstack-network-server/api certs/chirpstack-network-server/roaming certs/chirpstack-application-server/api certs/chirpstack-gateway-bridge/basicstation

docker:
	docker run --rm cfssl make

clean:
	rm -rf certs

certs/ca:
	mkdir -p certs/ca
	cfssl gencert -initca config/ca.json | cfssljson -bare certs/ca/ca
	cfssl gencert -initca config/ca-000000.json | cfssljson -bare certs/ca/ca-000000
	cfssl gencert -initca config/ca-000001.json | cfssljson -bare certs/ca/ca-000001
	cfssl sign -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile intermediate_ca certs/ca/ca-000000.csr | cfssljson -bare certs/ca/ca-000000
	cfssl sign -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile intermediate_ca certs/ca/ca-000001.csr | cfssljson -bare certs/ca/ca-000001

certs/chirpstack-network-server/api: certs/ca
	mkdir -p certs/chirpstack-network-server/api/server
	mkdir -p certs/chirpstack-network-server/api/client

	# chirpstack-network-server api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile server config/chirpstack-network-server/api/server/certificate.json | cfssljson -bare certs/chirpstack-network-server/api/server/chirpstack-network-server-api-server

	# chirpstack-network-server api client certificate (e.g. for chirpstack-application-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile client config/chirpstack-network-server/api/client/certificate.json | cfssljson -bare certs/chirpstack-network-server/api/client/chirpstack-network-server-api-client

certs/chirpstack-network-server/roaming: certs/ca
	mkdir -p certs/chirpstack-network-server/roaming/000000/server
	mkdir -p certs/chirpstack-network-server/roaming/000001/server
	mkdir -p certs/chirpstack-network-server/roaming/000000/client
	mkdir -p certs/chirpstack-network-server/roaming/000001/client

	# chirpstack-network-server roaming server certificates
	cfssl gencert -ca certs/ca/ca-000000.pem -ca-key certs/ca/ca-000000-key.pem -config config/config.json -profile server config/chirpstack-network-server/roaming/000000/server/certificate.json | cfssljson -bare certs/chirpstack-network-server/roaming/000000/server/chirpstack-network-server-roaming-000000-server
	cfssl gencert -ca certs/ca/ca-000001.pem -ca-key certs/ca/ca-000001-key.pem -config config/config.json -profile server config/chirpstack-network-server/roaming/000001/server/certificate.json | cfssljson -bare certs/chirpstack-network-server/roaming/000001/server/chirpstack-network-server-roaming-000001-server

	# chirpstack-network-server roaming server certificate chains
	cat certs/chirpstack-network-server/roaming/000000/server/chirpstack-network-server-roaming-000000-server.pem certs/ca/ca-000000.pem > certs/chirpstack-network-server/roaming/000000/server/chirpstack-network-server-roaming-000000-server-chain.pem
	cat certs/chirpstack-network-server/roaming/000001/server/chirpstack-network-server-roaming-000001-server.pem certs/ca/ca-000001.pem > certs/chirpstack-network-server/roaming/000001/server/chirpstack-network-server-roaming-000001-server-chain.pem

	# chirpstack-network-server roaming client certificates
	cfssl gencert -ca certs/ca/ca-000000.pem -ca-key certs/ca/ca-000000-key.pem -config config/config.json -profile client config/chirpstack-network-server/roaming/000000/client/certificate.json | cfssljson -bare certs/chirpstack-network-server/roaming/000000/client/chirpstack-network-server-roaming-000000-client
	cfssl gencert -ca certs/ca/ca-000001.pem -ca-key certs/ca/ca-000001-key.pem -config config/config.json -profile client config/chirpstack-network-server/roaming/000001/client/certificate.json | cfssljson -bare certs/chirpstack-network-server/roaming/000001/client/chirpstack-network-server-roaming-000001-client

	# chirpstack-network-server roaming server certificate chains
	cat certs/chirpstack-network-server/roaming/000000/client/chirpstack-network-server-roaming-000000-client.pem certs/ca/ca-000000.pem > certs/chirpstack-network-server/roaming/000000/client/chirpstack-network-server-roaming-000000-client-chain.pem
	cat certs/chirpstack-network-server/roaming/000001/client/chirpstack-network-server-roaming-000001-client.pem certs/ca/ca-000001.pem > certs/chirpstack-network-server/roaming/000001/client/chirpstack-network-server-roaming-000001-client-chain.pem

certs/chirpstack-application-server/api: certs/ca
	mkdir -p certs/chirpstack-application-server/api/server
	mkdir -p certs/chirpstack-application-server/api/client
	mkdir -p certs/chirpstack-application-server/join-api/server
	mkdir -p certs/chirpstack-application-server/join-api/client

	# chirpstack-application-server api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile server config/chirpstack-application-server/api/server/certificate.json | cfssljson -bare certs/chirpstack-application-server/api/server/chirpstack-application-server-api-server

	# chirpstack-application-server api client certificate (e.g. for chirpstack-network-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile client config/chirpstack-application-server/api/client/certificate.json | cfssljson -bare certs/chirpstack-application-server/api/client/chirpstack-application-server-api-client

	# chirpstack-application-server join api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile server config/chirpstack-application-server/join-api/server/certificate.json | cfssljson -bare certs/chirpstack-application-server/join-api/server/chirpstack-application-server-join-api-server

	# chirpstack-application-server join api client certificate (e.g. for chirpstack-network-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile client config/chirpstack-application-server/join-api/client/certificate.json | cfssljson -bare certs/chirpstack-application-server/join-api/client/chirpstack-application-server-join-api-client

certs/chirpstack-gateway-bridge/basicstation: certs/ca
	mkdir -p certs/chirpstack-gateway-bridge/basicstation/server
	mkdir -p certs/chirpstack-gateway-bridge/basicstation/client

	# basicstation websocket server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile server config/chirpstack-gateway-bridge/basicstation/server/certificate.json | cfssljson -bare certs/chirpstack-gateway-bridge/basicstation/server/basicstation-server

	# basicstation websocket client (gateway) certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/config.json -profile client config/chirpstack-gateway-bridge/basicstation/client/certificate.json | cfssljson -bare certs/chirpstack-gateway-bridge/basicstation/client/basicstation-client

