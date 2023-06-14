MQTT_BROKER_HOSTS ?= 127.0.0.1,localhost
CHIRPSTACK_GATEWAY_BRIDGE_HOSTS ?= 127.0.0.1,localhost

make: certs/ca \
	certs/chirpstack-gateway-bridge/basicstation \
	certs/mqtt-broker

set-hosts:
	./set-hosts.sh config/mqtt-broker/certificate.json $(MQTT_BROKER_HOSTS)
	./set-hosts.sh config/chirpstack-gateway-bridge/basicstation/certificate.json $(CHIRPSTACK_GATEWAY_BRIDGE_HOSTS)

docker:
	docker compose run --rm chirpstack-certificates

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
