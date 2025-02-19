#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo "Starting Post Create Command"

# Install mosquitto client
sudo apt-get update && sudo apt-get install mosquitto-clients -y

# Install NSS-myhostname for resolving hostnames
sudo apt-get update && sudo apt-get install libnss-myhostname -y

# Install mqttui
wget https://github.com/EdJoPaTo/mqttui/releases/download/v0.21.1/mqttui-v0.21.1-x86_64-unknown-linux-gnu.deb && \
    sudo apt-get install ./mqttui-v0.21.1-x86_64-unknown-linux-gnu.deb && \
    rm -rf ./mqttui-v0.21.1-x86_64-unknown-linux-gnu.deb

# Create local registry for K3D and local development
if [[ $(docker ps -f name=k3d-devregistry.localhost -q) ]]; then
    echo "Registry already exists so this is a rebuild of Dev Container, skipping"
else
    k3d registry create devregistry.localhost --port 5500
fi

echo "Ending Post Create Command"