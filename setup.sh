#!/bin/bash

HUB_NAME=IoTHubLASV2

printf "Installing Azure IoT extension ... (1/7)\n\n"

az extension add --name azure-cli-iot-ext

printf "\nCreating identities for the edge devices ... (2/7)\n\n"

az iot hub device-identity create --hub-name $HUB_NAME --device-id EdgeDevice1 --edge-enabled
az iot hub device-identity create --hub-name $HUB_NAME --device-id EdgeDevice2 --edge-enabled
CONN_STRING1=az iot hub device-identity show-connection-string --device-id EdgeDevice1 --hub-name $HUB_NAME
CONN_STRING2=az iot hub device-identity show-connection-string --device-id EdgeDevice2 --hub-name $HUB_NAME
az vm run-command invoke -g IoTEdgeResources -n EdgeVM1 --command-id RunShellScript --script '/etc/iotedge/configedge.sh "$CONN_STRING1"'
az vm run-command invoke -g IoTEdgeResources -n EdgeVM2 --command-id RunShellScript --script '/etc/iotedge/configedge.sh "$CONN_STRING2"'

printf "Setup complete!\n\n"