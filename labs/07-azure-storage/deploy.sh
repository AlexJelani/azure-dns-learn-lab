#!/bin/bash

# Lab 07 - Azure Storage Deployment Script
# This script deploys the Azure Storage lab infrastructure

set -e

echo "🚀 Starting Lab 07 - Azure Storage deployment..."

# Variables
RESOURCE_GROUP="az104-rg7"
LOCATION="East US"
DEPLOYMENT_NAME="lab07-storage-$(date +%Y%m%d-%H%M%S)"

# Check if Azure CLI is logged in
if ! az account show &> /dev/null; then
    echo "❌ Please log in to Azure CLI first: az login"
    exit 1
fi

# Create resource group
echo "📦 Creating resource group: $RESOURCE_GROUP"
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output table

# Deploy Bicep template
echo "🏗️  Deploying Azure Storage infrastructure..."
az deployment group create \
    --resource-group "$RESOURCE_GROUP" \
    --template-file main.bicep \
    --name "$DEPLOYMENT_NAME" \
    --output table

# Get deployment outputs
echo "📋 Deployment completed! Getting resource information..."
STORAGE_ACCOUNT=$(az deployment group show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$DEPLOYMENT_NAME" \
    --query "properties.outputs.storageAccountName.value" \
    --output tsv)

VNET_NAME=$(az deployment group show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$DEPLOYMENT_NAME" \
    --query "properties.outputs.virtualNetworkName.value" \
    --output tsv)

echo "✅ Lab 07 deployment completed successfully!"
echo ""
echo "📊 Created Resources:"
echo "   Resource Group: $RESOURCE_GROUP"
echo "   Storage Account: $STORAGE_ACCOUNT"
echo "   Virtual Network: $VNET_NAME"
echo "   Blob Container: data"
echo "   File Share: share1"
echo ""
echo "🔗 Next Steps:"
echo "   1. Navigate to Azure Portal: https://portal.azure.com"
echo "   2. Go to Storage Account: $STORAGE_ACCOUNT"
echo "   3. Test blob upload and file share access"
echo "   4. Configure network access rules"
echo ""
echo "🧹 To clean up: ./cleanup.sh"