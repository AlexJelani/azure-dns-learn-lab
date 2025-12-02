#!/bin/bash
set -e

echo "🧹 Cleaning up Azure Backup Lab..."

# Destroy with Terraform
echo "💥 Destroying resources..."
terraform destroy -auto-approve

echo "✅ Cleanup complete!"
echo "💰 Resources destroyed - no more charges!"