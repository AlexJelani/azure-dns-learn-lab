#!/bin/bash

RESOURCE_GROUP="az104-rg-nva-routing"

echo "Getting VM IP addresses..."

PUBLICIP=$(az vm list-ip-addresses \
    --resource-group "$RESOURCE_GROUP" \
    --name public \
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
    --output tsv)

PRIVATEIP=$(az vm list-ip-addresses \
    --resource-group "$RESOURCE_GROUP" \
    --name private \
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
    --output tsv)

echo "Public VM IP: $PUBLICIP"
echo "Private VM IP: $PRIVATEIP"
echo ""

echo "Testing route from public to private (should go through NVA at 10.0.2.4):"
ssh -t -o StrictHostKeyChecking=no azureuser@$PUBLICIP 'traceroute private --type=icmp; exit'

echo ""
echo "Testing route from private to public (should go direct):"
ssh -t -o StrictHostKeyChecking=no azureuser@$PRIVATEIP 'traceroute public --type=icmp; exit'