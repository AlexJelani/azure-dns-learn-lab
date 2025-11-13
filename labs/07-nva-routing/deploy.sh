#!/bin/bash

set -e

# Configuration
RESOURCE_GROUP="az104-rg-nva-routing"
LOCATION="eastus"
ADMIN_USERNAME="azureuser"

function usage() {
    echo "Usage: $0 <admin_password>"
    exit 1
}

if [ -z "$1" ]; then
    echo "Error: Admin password not provided."
    usage
fi
ADMIN_PASSWORD="$1"

echo "Starting NVA Routing Lab Deployment..."

# 1. Create Resource Group
echo "Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none

# 2. Deploy Network Infrastructure
echo "Deploying network infrastructure..."
az deployment group create \
    --resource-group "$RESOURCE_GROUP" \
    --template-file main.bicep \
    --parameters location="$LOCATION" \
    --output none

# 3. Deploy NVA VM
echo "Deploying NVA VM..."
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name nva \
    --vnet-name vnet \
    --subnet dmzsubnet \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --public-ip-address "" \
    --output none

# 4. Deploy Public VM
echo "Deploying public VM..."
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name public \
    --vnet-name vnet \
    --subnet publicsubnet \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data cloud-init.txt \
    --no-wait \
    --output none

# 5. Deploy Private VM
echo "Deploying private VM..."
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name private \
    --vnet-name vnet \
    --subnet privatesubnet \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --custom-data cloud-init.txt \
    --no-wait \
    --output none

# 6. Enable IP forwarding on NVA
echo "Enabling IP forwarding on NVA..."
NICNAME=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name nva \
    --query "networkProfile.networkInterfaces[0].id" \
    --output tsv | xargs basename)

az network nic update --name "$NICNAME" \
    --resource-group "$RESOURCE_GROUP" \
    --ip-forwarding true \
    --output none

# 7. Wait for VMs and configure NVA
echo "Waiting for VMs to be ready..."
az vm wait --resource-group "$RESOURCE_GROUP" --name nva --created
az vm wait --resource-group "$RESOURCE_GROUP" --name public --created
az vm wait --resource-group "$RESOURCE_GROUP" --name private --created

echo "Enabling IP forwarding within NVA..."
az vm run-command invoke \
    --resource-group "$RESOURCE_GROUP" \
    --name nva \
    --command-id RunShellScript \
    --scripts "sudo sysctl -w net.ipv4.ip_forward=1" \
    --output none

echo "Deployment completed!"
echo ""
echo "To test routing, run:"
echo "./test-routing.sh"