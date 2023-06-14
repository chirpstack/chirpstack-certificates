make: certs/ca \
	certs/chirpstack-gateway-bridge/basicstation \
	certs/mqtt-broker

docker:
	docker run --rm cfssl make

clean:
	rm -rf certs

certs/ca:
	mkdir -p certs/ca
	cfssl gencert -initca config/ca-csr.json | cfssljson -bare certs/ca/ca

certs/chirpstack-gateway-bridge/basicstation: certs/ca
	mkdir -p certs/chirpstack-gateway-bridge/basicstation

	# basicstation websocket server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/chirpstack-gateway-bridge/basicstation/certificate.json | cfssljson -bare certs/chirpstack-gateway-bridge/basicstation/basicstation

certs/mqtt-broker: certs/ca
	mkdir -p certs/mqtt-broker

	# MQTT broker / server certificate
	cfssl gencert -ca certs/ca/ca.pem -ca-key certs/ca/ca-key.pem -config config/ca-config.json -profile server config/mqtt-broker/certificate.json | cfssljson -bare certs/mqtt-broker/mqtt-broker
