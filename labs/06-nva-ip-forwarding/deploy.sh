#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
RESOURCE_GROUP_NAME="az104-rg-nva-lab" # Using a new RG name for this specific lab
LOCATION="eastus" # Or choose a suitable Azure region
NVA_VM_NAME="nva"
VNET_NAME="vnet"
DMZ_SUBNET_NAME="dmzsubnet"
ADMIN_USERNAME="azureuser"
# Password will be passed as an argument

# --- Functions ---
function usage() {
    echo "Usage: $0 <admin_password>"
    echo "  <admin_password>: Password for the NVA VM admin user. Must be complex."
    exit 1
}

# --- Main Script ---

# Check for admin password argument
if [ -z "$1" ]; then
    echo "Error: Admin password not provided."
    usage
fi
ADMIN_PASSWORD="$1"

echo "Starting NVA Lab Deployment..."
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"

# 1. Create Resource Group
echo "Creating resource group $RESOURCE_GROUP_NAME..."
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" --output none

# 2. Deploy Network Infrastructure (VNet and Subnets) using Bicep
echo "Deploying network infrastructure (VNet, Subnets) using Bicep..."
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file main.bicep \
    --parameters location="$LOCATION" \
    --output none

echo "Network infrastructure deployed."

# 3. Deploy the NVA virtual machine
echo "Deploying NVA virtual machine '$NVA_VM_NAME' to '$DMZ_SUBNET_NAME'..."
az vm create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$NVA_VM_NAME" \
    --vnet-name "$VNET_NAME" \
    --subnet "$DMZ_SUBNET_NAME" \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --admin-username "$ADMIN_USERNAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --public-ip-address "" \
    --output none

echo "NVA VM '$NVA_VM_NAME' deployed."

# 4. Enable IP forwarding for the Azure network interface
echo "Enabling IP forwarding for the NVA's Azure network interface..."

NICNAME=$(az vm show \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$NVA_VM_NAME" \
    --query "networkProfile.networkInterfaces[0].id" \
    --output tsv | xargs basename)

if [ -z "$NICNAME" ]; then
    echo "Error: Could not retrieve NVA network interface name."
    exit 1
fi

az network nic update --name "$NICNAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --ip-forwarding true \
    --output none

echo "IP forwarding enabled on Azure NIC."

# 5. Enable IP forwarding within the appliance using az vm run-command
echo "Enabling IP forwarding within the NVA virtual machine using 'az vm run-command'..."
az vm run-command invoke \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$NVA_VM_NAME" \
    --command-id RunShellScript \
    --scripts "sudo sysctl -w net.ipv4.ip_forward=1" \
    --output none

echo "IP forwarding enabled within the NVA."

# Note: The original lab created a public IP. This version does not for better security.
# If you need to SSH, you would typically use Azure Bastion or a jumpbox in a public subnet.

echo "NVA Lab Deployment Completed Successfully!"
echo "The NVA does not have a public IP address."
