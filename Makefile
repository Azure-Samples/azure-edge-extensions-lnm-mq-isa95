#! /bin/bash
K3DCLUSTERNAME := devcluster
K3DREGISTRYNAME := k3d-devregistry.localhost:5500
PORTFORWARDING := -p '18883:18883@loadbalancer' -p '1883:1883@loadbalancer'
ARCCLUSTERNAME := arc-mqtt-isa95
STORAGEACCOUNTNAME := samqttisa95
SCHEMAREGISTRYNAME := sr-mqtt-isa95
RESOURCEGROUP := rg-mqtt-isa95
LOCATION := westeurope

all: create_k3d_cluster_1 deploy_aio_1 deploy_opcplcsimulator deploy_mqttui

create_k3d_cluster_1:
	@echo "Creating k3d cluster..."
	k3d cluster create $(K3DCLUSTERNAME)-1 $(PORTFORWARDING) --registry-use $(K3DREGISTRYNAME) --servers 1

deploy_aio_1:
	@echo "Deploying AIO..."
	bash ./infra/deploy-aio.sh $(ARCCLUSTERNAME)-1 $(STORAGEACCOUNTNAME)1 $(SCHEMAREGISTRYNAME)-1 $(RESOURCEGROUP)-1 $(LOCATION)

deploy_opcplcsimulator:
	@echo "Deploying OPC PLC Simulator..."
	kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/explore-iot-operations/main/samples/quickstarts/opc-plc-deployment.yaml

deploy_mqttui:
	@echo "Deploying mqttui tool..."
	kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/explore-iot-operations/main/samples/quickstarts/mqtt-client.yaml

clean:
	@echo "Cleaning up..."
	k3d cluster delete $(K3DCLUSTERNAME)
	az group delete -n $RESOURCEGROUP --yes
