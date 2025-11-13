#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

RESOURCE_GROUP_NAME="az104-rg-nva-lab" # Must match the deploy.sh script

echo "Starting NVA Lab Cleanup..."
echo "Deleting resource group: $RESOURCE_GROUP_NAME"

az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait

echo "Resource group deletion initiated. It may take some time to complete."
echo "NVA Lab Cleanup script finished."
