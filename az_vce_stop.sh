#!/usr/bin/env bash

groupname=tj_VELO_vVCE_RG

read -n 1 -p "Are you sure to stop kill the setup? Press any key..." any

echo "Deleting ResourceGroup... (This may take some time...)"
az group delete --name $groupname

echo "Finished script!"