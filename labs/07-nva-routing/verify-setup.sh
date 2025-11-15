#!/bin/bash

RESOURCE_GROUP="az104-rg-nva-routing"

echo "=== NVA Routing Lab Verification ==="
echo ""

echo "1. Checking VMs status:"
az vm list \
    --resource-group "$RESOURCE_GROUP" \
    --show-details \
    --query '[*].{Name:name, PowerState:powerState, PrivateIP:privateIps}' \
    --output table

echo ""
echo "2. Checking route table configuration:"
az network route-table route list \
    --resource-group "$RESOURCE_GROUP" \
    --route-table-name publictable \
    --output table

echo ""
echo "3. Checking NVA IP forwarding:"
NICNAME=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name nva \
    --query "networkProfile.networkInterfaces[0].id" \
    --output tsv | xargs basename)

az network nic show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$NICNAME" \
    --query '{Name:name, IpForwarding:enableIpForwarding}' \
    --output table

echo ""
echo "4. Network topology:"
echo "  Public VM (10.0.0.x) → Route Table → NVA (10.0.2.4) → Private VM (10.0.1.x)"
echo "  Private VM (10.0.1.x) → Direct → Public VM (10.0.0.x)"
echo ""
echo "✅ Lab setup verification complete!"