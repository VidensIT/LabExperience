#!/usr/bin/env bash

groupname=tj_VELO_vVCE_RG
securitygroup=tj_VELO_vVCE_SG
vnetname=tj_VELO_vVCE_AZURE
networknames=tj_VELO_vVCE_SN
publicrt=tj_VELO_vVCE_RT
privatert=tj_VELO_vVCE_RT_PRIVATE
vm_name=tjvVCE01
vmjh_name=tjJHVCE
vmlh_name=tjLHVCE
location=westeurope
address='10.0.0.0/16'
wansubnet='10.0.0.'
lansubnet='10.0.1.'
jhsubnet='10.0.2.'

#TODO Create deletion

echo "Create resource group: $groupname"
echo "Using location $location"
az group create --name $groupname --location $location
echo "Create security group..."
az network nsg create \
  --resource-group $groupname \
  --name $securitygroup \
  --location $location
echo "Creating rules..."
az network nsg rule create \
  --resource-group $groupname \
  --nsg-name $securitygroup \
  --name Allow_SSH \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 1000 \
  --source-address-prefix "*" \
  --source-port-range "*" \
  --destination-port-range 22
az network nsg rule create \
  --resource-group $groupname \
  --nsg-name $securitygroup \
  --name VELOCLOUD \
  --access Allow \
  --protocol Udp \
  --direction Inbound \
  --priority 2000 \
  --source-address-prefix "*" \
  --source-port-range "*" \
  --destination-address-prefixes "*" \
  --destination-port-range 2426

echo "Creating networks..."
az network vnet create -g $groupname \
    -n $vnetname \
    --address-prefix $address \
    --subnet-name $networknames'_Public_WAN' \
    --subnet-prefix $wansubnet'0/24'
az network vnet subnet create \
    --address-prefix $jhsubnet'0/24' \
    --name $networknames'_Public_JH' \
    --resource-group $groupname \
    --vnet-name $vnetname
az network vnet subnet create \
    --address-prefix $lansubnet'0/24' \
    --name $networknames'_Private_LAN' \
    --resource-group $groupname \
    --vnet-name $vnetname

echo "Creating routing tables..."
az network route-table create \
    -g $groupname \
    -n $publicrt
az network route-table create \
    -g $groupname \
    -n $privatert

echo "Assign subnets to routing tables and security groups..."
az network vnet subnet update -g $groupname \
    --vnet-name $vnetname \
    -n $networknames'_Public_WAN' \
    --network-security-group $securitygroup \
    --route-table $publicrt
az network vnet subnet update -g $groupname \
    --vnet-name $vnetname \
    --network-security-group $securitygroup \
    -n $networknames'_Public_JH' \
    --route-table $publicrt
az network vnet subnet update -g $groupname \
    --vnet-name $vnetname \
    --network-security-group $securitygroup \
    -n $networknames'_Private_LAN' \
    --route-table $privatert

echo "Creating routes..."
az network route-table route create \
    -g $groupname --route-table-name $publicrt \
    -n DefaultGW \
    --next-hop-type Internet --address-prefix 0.0.0.0/0
az network route-table route create \
    -g $groupname --route-table-name $publicrt \
    -n VELO_vVCE_CI_WAN \
    --next-hop-type VirtualAppliance --address-prefix $lansubnet'0/24' \
    --next-hop-ip-address $wansubnet'11'
az network route-table route create \
    -g $groupname --route-table-name $privatert \
    -n DefaultRoute \
    --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 \
    --next-hop-ip-address $lansubnet'41'

echo "Create Jumphost and LANhost..."
az vm create --name $vmjh_name --size Standard_A1 --resource-group $groupname --vnet-name $vnetname --subnet $networknames'_Public_JH' --image UbuntuLTS --generate-ssh-keys
az vm create --name $vmlh_name --size Standard_A1 --resource-group $groupname --vnet-name $vnetname --subnet $networknames'_Public_JH' --image UbuntuLTS --generate-ssh-keys
az vm stop -g $groupname -n $vmlh_name
az vm deallocate -g $groupname -n $vmlh_name

#TODO Automation for creation (check template)
echo "Creating VM ($vm_name)..."
#az vm create --name $vm_name \
#    --size $edgesize \
#    --resource-group $groupname \
#    --image $edgeimage \
#    --generate-ssh-keys \
#    --admin-username vcadmin \
#    --vnet-name $vnetname \
#    --subnet $networknames'_Public_JH' \
#    --nsg $securitygroup

echo "Create host in portal..."
echo "Name: $vm_name"
echo "UserName: vcadmin"
echo "Copy your public key"
echo "Assign to resource group: $groupname"
echo "Assign to location: $location"
echo "Choose default size"

read -n 1 -p "Wait for resource creation, press any key…" any

echo "Stop VM for changes..."
az vm stop -g $groupname -n $vm_name
az vm deallocate -g $groupname -n $vm_name

echo "Creating network setup vVCE..."
az network public-ip create \
    --name vvce-mp-ge2-wan-ip \
    --resource-group $groupname
az network nic create \
    --resource-group $groupname \
    --name vvce-mp-ge2 \
    --location $location \
    --subnet $networknames'_Public_WAN' \
    --private-ip-address $wansubnet'41' \
    --ip-forwarding \
    --vnet-name $vnetname \
    --public-ip-address vvce-mp-ge2-wan-ip
az network nic create \
    --resource-group $groupname \
    --name vvce-mp-ge3 \
    --location $location \
    --subnet $networknames'_Private_LAN' \
    --private-ip-address $lansubnet'41' \
    --ip-forwarding \
    --vnet-name $vnetname
az network nic create \
    --resource-group $groupname \
    --name lan-lh \
    --location $location \
    --subnet $networknames'_Private_LAN' \
    --private-ip-address $lansubnet'42' \
    --ip-forwarding \
    --vnet-name $vnetname
az vm nic add \
    --nics vvce-mp-ge2 vvce-mp-ge3 \
    --resource-group $groupname \
    --vm-name $vm_name
az vm nic add \
    --nics lan-lh \
    --resource-group $groupname \
    --vm-name $vmlh_name

read -n 1 -p "Wait for resource creation, press any key…" any

echo "Start VM..."
az vm start -g $groupname -n $vm_name
az vm start -g $groupname -n $vmlh_name



echo "Finished script!"
exit 1