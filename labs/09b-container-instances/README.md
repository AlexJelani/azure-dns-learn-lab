# Lab 09b - Implement Azure Container Instances

Deploy and test Azure Container Instances using Terraform.

## What it creates

- **Resource Group**: `az104-rg9`
- **Container Instance**: `az104-c1` running hello-world app
- **Public IP**: Accessible via generated FQDN
- **DNS Label**: `az104-c1-[random]`

## Quick Start

1. **Deploy**:
   ```bash
   cd labs/09b-container-instances
   terraform init
   terraform plan
   terraform apply
   ```

2. **Test**: Visit the FQDN shown in output

3. **Cleanup**:
   ```bash
   terraform destroy
   ```

## Verification Steps

1. Check container status in Azure Portal
2. Browse to the FQDN URL
3. View container logs in Portal → Container Instance → Containers → Logs

## Estimated Cost
< $0.01 for 15-minute lab (ACI charges per second)