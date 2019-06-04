printf "Installing Azure IoT extension ... \n\n"

az extension add --name azure-cli-iot-ext

printf "\nCreating identities for the edge devices ...\n\n"

az iot hub device-identity create --hub-name IoTHubLASV2 --device-id EdgeDevice1 --edge-enabled
az iot hub device-identity create --hub-name IoTHubLASV2 --device-id EdgeDevice2 --edge-enabled
connection1=$(az iot hub device-identity show-connection-string \
    --device-id EdgeDevice1 \
    --hub-name IoTHubLASV2)
connection2=$(az iot hub device-identity show-connection-string \
    --device-id EdgeDevice2 \
    --hub-name IoTHubLASV2)

printf "\nAdding device identities to VMs ...\n\n"

az vm run-command invoke -g IoTEdgeResources -n EdgeVM1 --command-id RunShellScript --script '/etc/iotedge/configedge.sh "connection1"'
az vm run-command invoke -g IoTEdgeResources -n EdgeVM2 --command-id RunShellScript --script '/etc/iotedge/configedge.sh "connection2"'

printf "\nAdding tags to devices ...\n\n"

az iot hub device-twin update --device-id EdgeDevice1 --hub-name IoTHubLASV2 --set tags='{"location":{"region":"ES"}}'
az iot hub device-twin update --device-id EdgeDevice2 --hub-name IoTHubLASV2 --set tags='{"location":{"region":"ES"}}'


printf "Setup complete!\n\n"