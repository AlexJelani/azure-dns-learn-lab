# Lab 10 - Protect Virtual Machines with Azure Backup

Deploy and configure Azure Backup to protect virtual machines using Terraform.

## What it creates

- **Resource Group**: `az104-rg10`
- **Virtual Machine**: `az104-vm1` (Ubuntu 22.04 LTS)
- **Virtual Network**: `az104-vnet1` with subnet
- **Recovery Services Vault**: `az104-vault-[random]`
- **Backup Policy**: Daily backups with retention policies
- **VM Protection**: Automatic backup configuration

## Prerequisites

- SSH key pair in `~/.ssh/id_rsa.pub` (create with `ssh-keygen -t rsa`)
- Azure CLI logged in
- Terraform installed

## Quick Start

1. **Generate SSH key** (if needed):
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

2. **Deploy**:
   ```bash
   cd labs/10-azure-backup
   terraform init
   terraform plan
   terraform apply
   ```

3. **Test VM connection**:
   ```bash
   # Use the SSH command from terraform output
   ssh adminuser@<public-ip>
   ```

4. **Cleanup**:
   ```bash
   terraform destroy
   ```

## DevOps Integration

### Automated Scripts:
```bash
# Deploy everything
./deploy.sh

# Cleanup everything  
./cleanup.sh
```

### GitHub Actions:
- **CI/CD Pipeline**: `.github/workflows/azure-backup-lab.yml`
- **Auto-deploy** on push to main
- **Validate** on pull requests
- **Manual cleanup** via workflow dispatch

### Setup CI/CD:
1. Create Azure service principal:
   ```bash
   az ad sp create-for-rbac --name "github-backup-lab" --role contributor --scopes /subscriptions/<subscription-id> --sdk-auth
   ```
2. Add output as `AZURE_CREDENTIALS` secret in GitHub
3. Push changes to trigger pipeline

## Verification Steps

### 1. Check VM Status
- Navigate to Azure Portal → Virtual Machines
- Verify `az104-vm1` is running

### 2. Verify Backup Configuration
- Go to Recovery Services Vault → `az104-vault-[random]`
- Check Backup Items → Azure Virtual Machine
- Verify `az104-vm1` is listed and protected

### 3. Review Backup Policy
- In Recovery Services Vault → Backup policies
- Check `az104-backup-policy` settings:
  - Daily backup at 23:00
  - 10 days daily retention
  - 42 weeks weekly retention
  - 7 months monthly retention
  - 77 years yearly retention

### 4. Trigger Manual Backup (Optional)
- Go to VM → Operations → Backup
- Click "Backup now" to create immediate backup
- Monitor backup job progress

### 5. Test File Recovery (Optional)
- SSH to VM and create test files
- Trigger backup
- Use file recovery feature to mount backup as disk

## Key Learning Points

1. **Recovery Services Vault**: Central repository for backups
2. **Backup Policies**: Define schedule and retention rules
3. **VM Protection**: Automatic backup configuration
4. **Soft Delete**: Protection against accidental deletion
5. **Cross-Region Restore**: Disaster recovery capabilities

## Backup Policy Details

- **Frequency**: Daily at 23:00 UTC
- **Daily Retention**: 10 days
- **Weekly Retention**: 42 weeks (Sun, Wed, Fri, Sat)
- **Monthly Retention**: 7 months (First and Last Sunday/Wednesday)
- **Yearly Retention**: 77 years (Last Sunday of January)

## Cost Estimation

- **VM**: ~$7.30/month (Standard_B1s)
- **Storage**: ~$0.05/GB/month for backup storage
- **Recovery Services Vault**: No additional charge
- **Total for lab**: < $0.50 for 2-hour exercise

## Troubleshooting

### SSH Key Issues
```bash
# Generate new key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Check public key exists
cat ~/.ssh/id_rsa.pub
```

### Backup Job Failures
- Check VM agent status in Azure Portal
- Verify VM has internet connectivity
- Review backup job logs in Recovery Services Vault

### Network Connectivity
- Verify NSG rules allow SSH (port 22)
- Check public IP allocation
- Confirm VM is running

## Exercise Source

Based on Microsoft Learn: [Protect virtual machines with Azure Backup](https://learn.microsoft.com/en-us/training/modules/protect-virtual-machines-with-azure-backup/)