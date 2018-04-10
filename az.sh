#!/usr/bin/env bash

az group create --name tj_resource_group --location westeurope
az vm create --name tjlinuxfiletransferserver --size Standard_A1 --resource-group tj_resource_group --image debian --generate-ssh-keys
az vm open-port --port 80 --resource-group tj_resource_group --name tjlinuxfiletransferserver
az vm get-instance-view --name tjlinuxfiletransferserver --resource-group tj_resource_group
az vm list-ip-addresses --resource-group tj_resource_group --name tjlinuxfiletransferserver --output table

read -n 1 -p "Wait for user to stop, press any key…" any
az vm stop --resource-group tj_resource_group --name tjlinuxfiletransferserver
az group delete --name tj_resource_group
