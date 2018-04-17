#!/usr/bin/env bash

groupname=tj_VELO_vVCE_RG
securitygroup=tj_VELO_vVCE_SG
vnetname=tj_VELO_vVCE_AZURE
networknames=tj_VELO_vVCE_SN
publicrt=tj_VELO_vVCE_RT
privatert=tj_VELO_vVCE_RT_PRIVATE
vm_name=tj_vVCE01
location=westeurope
edgeimage=velocloud-virtual-edge-3x


#TODO Create deletion

echo "Create resource group: $groupname"
echo "Using location $location"
#az group create --name $groupname --location $location
echo "Create security group..."
#az network nsg create \
#  --resource-group $groupname \
#  --name $securitygroup \
#  --location $location
echo "Creating rules..."
#az network nsg rule create \
#  --resource-group $groupname \
#  --nsg-name $securitygroup \
#  --name Allow_SSH \
#  --access Allow \
#  --protocol Tcp \
#  --direction Inbound \
#  --priority 1000 \
#  --source-address-prefix "*" \
#  --source-port-range "*" \
#  --destination-port-range 22
#az network nsg rule create \
#  --resource-group $groupname \
#  --nsg-name $securitygroup \
#  --name VELOCLOUD \
#  --access Allow \
#  --protocol Udp \
#  --direction Inbound \
#  --priority 2000 \
#  --source-address-prefix "*" \
#  --source-port-range "*" \
#  --destination-address-prefixes "*" \
#  --destination-port-range 2426

echo "Creating networks..."
#az network vnet create -g $groupname \
#    -n $vnetname \
#    --address-prefix 172.16.0.0/16 \
#    --subnet-name $networknames'_Public_WAN' \
#    --subnet-prefix 172.16.1.0/24
#az network vnet subnet create \
#    --address-prefix 172.16.2.0/24 \
#    --name $networknames'_Public_JH' \
#    --resource-group $groupname \
#    --vnet-name $vnetname
#az network vnet subnet create \
#    --address-prefix 172.16.132.0/24 \
#    --name $networknames'_Private_LAN' \
#    --resource-group $groupname \
#    --vnet-name $vnetname

echo "Creating routing tables..."
#az network route-table create \
#    -g $groupname \
#    -n $publicrt
#az network route-table create \
#    -g $groupname \
#    -n $privatert

echo "Assign subnets to routing tables and security groups..."
#az network vnet subnet update -g $groupname \
#    --vnet-name $vnetname \
#    -n $networknames'_Public_WAN' \
#    --network-security-group $securitygroup \
#    --route-table $publicrt
#az network vnet subnet update -g $groupname \
#    --vnet-name $vnetname \
#    --network-security-group $securitygroup \
#    -n $networknames'_Public_JH' \
#    --route-table $publicrt
#az network vnet subnet update -g $groupname \
#    --vnet-name $vnetname \
#    --network-security-group $securitygroup \
#    -n $networknames'_Private_LAN' \
#    --route-table $privatert

echo "Creating routes..."
#az network route-table route create \
#    -g $groupname --route-table-name $publicrt \
#    -n DefaultGW \
#    --next-hop-type Internet --address-prefix 0.0.0.0/0
#az network route-table route create \
#    -g $groupname --route-table-name $publicrt \
#    -n VELO_vVCE_CI_WAN \
#    --next-hop-type VirtualAppliance --address-prefix 172.16.132.0/24 \
#    --next-hop-ip-address 172.16.1.11
#az network route-table route create \
#    -g $groupname --route-table-name $privatert \
#    -n DefaultRoute \
#    --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 \
#    --next-hop-ip-address 172.16.132.11


echo "Creating VM ($vm_name)..."
#az vm create --name $vm_name --size Standard_A1 --resource-group $groupname --image $edgeimage --generate-ssh-keys
#
#echo "Wait for 1 minute before page becomes reachable, CloudInit is setting up the host..."
#read -n 1 -p "Wait for user to stop, press any key…" any
#echo "Stopping VM..."
#az vm stop --resource-group $groupname --name $vm_name
#echo "Deleting ResourceGroup... (This may take some time...)"
#az group delete --name $groupname
echo "Finished script!"