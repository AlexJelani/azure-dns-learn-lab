#!/bin/bash
set -e

echo "🚀 Deploying Azure Backup Lab..."

# Generate SSH key if not exists
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "📝 Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

# Deploy with Terraform
echo "🏗️ Initializing Terraform..."
terraform init

echo "📋 Planning deployment..."
terraform plan

echo "🚀 Applying configuration..."
terraform apply -auto-approve

# Get outputs
VM_IP=$(terraform output -raw vm_public_ip)
VAULT_NAME=$(terraform output -raw recovery_vault_name)

echo "✅ Deployment complete!"
echo "🖥️  VM IP: $VM_IP"
echo "🔒 Vault: $VAULT_NAME"
echo "🔑 SSH: ssh adminuser@$VM_IP"

# Test connection
echo "🧪 Testing VM connection..."
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 adminuser@$VM_IP "hostname && uptime" || echo "⚠️  SSH test failed (VM may still be starting)"

echo "🎉 Lab ready!"