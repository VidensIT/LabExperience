#!/usr/bin/env bash

groupname=tj_resource_group
vm_name=tjfilehttpserverloc1
location=westeurope

echo "Create resource group: $groupname"
echo "Using location $location"
az group create --name $groupname --location $location
echo "Creating VM ($vm_name)..."
az vm create --name $vm_name --size Standard_A1 --resource-group $groupname --image UbuntuLTS --generate-ssh-keys --custom-data az-ubuntu-cloud-init.txt
echo "Opening port 80..."
az vm open-port --port 80 --resource-group $groupname --name $vm_name
echo "Get public IP and VM Status..."
az vm get-instance-view --name $vm_name --resource-group $groupname
az vm list-ip-addresses --resource-group $groupname --name $vm_name --output table

echo "Wait for 1 minute before page becomes reachable, CloudInit is setting up the host..."
read -n 1 -p "Wait for user to stop, press any key…" any
echo "Stopping VM..."
az vm stop --resource-group $groupname --name $vm_name
echo "Deleting ResourceGroup... (This may take some time...)"
az group delete --name $groupname
echo "Finished script!"