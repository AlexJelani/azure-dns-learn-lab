#!/bin/bash

# Custom Routes Exercise - Azure CLI Deployment
RESOURCE_GROUP="learn-custom-routes-rg"
LOCATION="eastus"

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating route table..."
az network route-table create \
    --name publictable \
    --resource-group $RESOURCE_GROUP \
    --disable-bgp-route-propagation false

echo "Creating custom route..."
az network route-table route create \
    --route-table-name publictable \
    --resource-group $RESOURCE_GROUP \
    --name productionsubnet \
    --address-prefix 10.0.1.0/24 \
    --next-hop-type VirtualAppliance \
    --next-hop-ip-address 10.0.2.4

echo "Creating virtual network and public subnet..."
az network vnet create \
    --name vnet \
    --resource-group $RESOURCE_GROUP \
    --address-prefixes 10.0.0.0/16 \
    --subnet-name publicsubnet \
    --subnet-prefixes 10.0.0.0/24

echo "Creating private subnet..."
az network vnet subnet create \
    --name privatesubnet \
    --vnet-name vnet \
    --resource-group $RESOURCE_GROUP \
    --address-prefixes 10.0.1.0/24

echo "Creating DMZ subnet..."
az network vnet subnet create \
    --name dmzsubnet \
    --vnet-name vnet \
    --resource-group $RESOURCE_GROUP \
    --address-prefixes 10.0.2.0/24

echo "Associating route table with public subnet..."
az network vnet subnet update \
    --name publicsubnet \
    --vnet-name vnet \
    --resource-group $RESOURCE_GROUP \
    --route-table publictable

echo "Deployment complete! Listing subnets:"
az network vnet subnet list \
    --resource-group $RESOURCE_GROUP \
    --vnet-name vnet \
    --output table