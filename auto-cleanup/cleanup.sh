#!/bin/bash
# Auto-cleanup script for cost control

# Get current month cost
CURRENT_COST=$(az rest --method POST --url "https://management.azure.com/subscriptions/$(az account show --query id -o tsv)/providers/Microsoft.CostManagement/query?api-version=2021-10-01" --body '{"type":"ActualCost","timeframe":"MonthToDate","dataset":{"aggregation":{"totalCost":{"name":"PreTaxCost","function":"Sum"}}}}' --query "properties.rows[0][0]" -o tsv)

echo "Current month cost: ¥$CURRENT_COST"

# If cost exceeds 100 yen, cleanup expensive resources
if (( $(echo "$CURRENT_COST > 100" | bc -l) )); then
    echo "Cost exceeded ¥100! Cleaning up expensive resources..."
    
    # Delete expensive resource groups
    az group delete --name dns-alias-rg --yes --no-wait 2>/dev/null || echo "dns-alias-rg already deleted"
    az group delete --name TestResourceGroup --yes --no-wait 2>/dev/null || echo "TestResourceGroup already deleted"
    
    # Stop VMs instead of deleting (safer option)
    az vm deallocate --ids $(az vm list --query "[].id" -o tsv) --no-wait 2>/dev/null || echo "No VMs to stop"
    
    echo "Cleanup initiated!"
else
    echo "Cost under control (¥$CURRENT_COST < ¥100)"
fi