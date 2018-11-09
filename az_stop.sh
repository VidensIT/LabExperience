#!/usr/bin/env bash

groupname=tj_resource_group
vm_name=tjfilehttpserverloc1
location=westeurope

echo "Stopping VM..."
az vm stop --resource-group $groupname --name $vm_name
echo "Deleting ResourceGroup... (This may take some time...)"
az group delete --name $groupname
echo "Finished script!"