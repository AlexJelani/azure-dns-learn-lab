# Azure DNS Learn Lab

This repository contains Infrastructure as Code (IaC) templates to complete the Azure DNS learning exercise from Microsoft Learn.

## What it creates

- Resource Group: `learn-dns-rg`
- DNS Zone: `wideworldimports111125.com`
- A Record: `www` → `10.10.10.10`

## Architecture

### Terraform Files
- `main.tf` - Main Terraform configuration
- `terraform.tfstate` - State file (auto-generated)

### Bicep Files
- `main.bicep` - Main Bicep template
- `dns.bicep` - DNS resources module
- `main.parameters.json` - Parameters file

### CI/CD Pipelines
- `.github/workflows/terraform.yml` - Terraform deployment
- `.github/workflows/bicep.yml` - Bicep deployment
- `.github/workflows/cleanup.yml` - Resource cleanup

## Deployment Options

### Terraform

```bash
terraform init
terraform apply
```

Verify DNS:
```bash
nslookup www.wideworldimports111125.com <name_server_from_output>
```

Clean up:
```bash
terraform destroy
```

### Bicep

```bash
az deployment sub create --location japaneast --template-file main.bicep
```

With parameters:
```bash
az deployment sub create --location japaneast --template-file main.bicep --parameters main.parameters.json
```

## CI/CD Setup

1. Create Azure service principal:
```bash
az ad sp create-for-rbac --name "github-actions" --role contributor --scopes /subscriptions/<subscription-id> --sdk-auth
```

2. Add the output as `AZURE_CREDENTIALS` secret in GitHub repository settings

3. Pipelines trigger on:
   - **Terraform**: Push to main with `.tf` file changes
   - **Bicep**: Push to main with `.bicep` or `.json` file changes
   - **Cleanup**: Manual trigger only

## Cost

Estimated cost: < $0.05 for completing the exercise (DNS zone is $0.50/month, prorated).

## Exercise Source

Based on Microsoft Learn: [Host your domain on Azure DNS](https://docs.microsoft.com/en-us/learn/modules/host-domain-azure-dns/)