make: certs/ca certs/loraserver/api certs/lora-app-server/api

docker:
	docker run --rm cfssl make

clean:
	rm -rf certs

certs/ca:
	mkdir -p certs/ca
	cfssl gencert -initca config/ca-csr.json | cfssljson -bare certs/ca/ca

certs/loraserver/api: certs/ca
	mkdir -p certs/loraserver/api/server
	mkdir -p certs/loraserver/api/client

	# loraserver api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/loraserver/api/server/certificate.json | cfssljson -bare certs/loraserver/api/server/loraserver-api-server

	# loraserver api client certificate (e.g. for lora-app-server)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/loraserver/api/client/certificate.json | cfssljson -bare certs/loraserver/api/client/loraserver-api-client

certs/lora-app-server/api: certs/ca
	mkdir -p certs/lora-app-server/api/server
	mkdir -p certs/lora-app-server/api/client

	# lora-app-server api server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/lora-app-server/api/server/certificate.json | cfssljson -bare certs/lora-app-server/api/server/lora-app-server-api-server

	# lora-app-server api client certificate (e.g. for loraserver)
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile client config/lora-app-server/api/client/certificate.json | cfssljson -bare certs/lora-app-server/api/client/lora-app-server-api-client
