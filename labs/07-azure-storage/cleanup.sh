#!/bin/bash

# Lab 07 - Azure Storage Cleanup Script
# This script removes all resources created for the Azure Storage lab

set -e

echo "🧹 Starting Lab 07 - Azure Storage cleanup..."

# Variables
RESOURCE_GROUP="az104-rg7"

# Check if Azure CLI is logged in
if ! az account show &> /dev/null; then
    echo "❌ Please log in to Azure CLI first: az login"
    exit 1
fi

# Check if resource group exists
if ! az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    echo "ℹ️  Resource group '$RESOURCE_GROUP' does not exist. Nothing to clean up."
    exit 0
fi

# Confirm deletion
echo "⚠️  This will delete the entire resource group: $RESOURCE_GROUP"
echo "   This action cannot be undone!"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup cancelled."
    exit 0
fi

# Delete resource group
echo "🗑️  Deleting resource group: $RESOURCE_GROUP"
echo "   This may take several minutes..."

az group delete \
    --name "$RESOURCE_GROUP" \
    --yes \
    --no-wait

echo "✅ Cleanup initiated successfully!"
echo "   Resource group '$RESOURCE_GROUP' is being deleted in the background."
echo "   You can check the status in the Azure Portal."