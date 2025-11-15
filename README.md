# Azure DNS Labs Collection

This repository contains multiple Azure DNS labs with Infrastructure as Code (IaC) templates using both Terraform and Bicep.

## 📚 Available Labs

| Lab | Description | Technologies |
|-----|-------------|-------------|
| [01 - Basic DNS](labs/01-basic-dns/) | Create DNS zone and A record | Terraform, Bicep |
| [02 - Alias Records](labs/02-alias-records/) | Load balancer with alias records | Terraform |
| [03 - Private DNS](labs/03-private-dns/) | Private DNS zones (Coming Soon) | Terraform |
| [04 - Traffic Manager](labs/04-traffic-manager/) | Global load balancing (Coming Soon) | Terraform |
| [07 - Azure Storage](labs/07-azure-storage/) | Manage storage accounts, blobs, and file shares | Terraform, Bicep |

## What it creates

- Resource Group: `learn-dns-rg`
- DNS Zone: `wideworldimports111125.com`
- A Record: `www` → `10.10.10.10`

## 🏢 Repository Structure

```
azure-dns-labs/
├── labs/
│   ├── 01-basic-dns/          # Basic DNS zone and A record
│   │   ├── main.tf
│   │   ├── main.bicep
│   │   └── README.md
│   ├── 02-alias-records/      # Load balancer with alias records
│   │   ├── main.tf
│   │   └── README.md
│   ├── 03-private-dns/        # Private DNS zones
│   ├── 04-traffic-manager/    # Global load balancing
│   └── 07-azure-storage/      # Azure Storage management
│       ├── main.tf
│       ├── main.bicep
│       └── README.md
├── .github/workflows/     # CI/CD pipelines
├── .devcontainer/         # Auto-setup tools
└── README.md
```

## 🚀 Quick Start

1. **Choose a lab** from the table above
2. **Navigate to lab directory**: `cd labs/01-basic-dns`
3. **Follow lab-specific README** for deployment instructions
4. **Clean up** resources after completion

## 🛠️ Development Environment

This repository includes a `.devcontainer` configuration that automatically installs:
- Terraform
- Azure CLI
- VS Code extensions
- Additional development tools

Just launch a Codespace and everything is ready to go!

## 📊 Learning Path

**Recommended order:**
1. **Basic DNS** - Learn DNS fundamentals
2. **Alias Records** - Understand dynamic DNS with load balancers
3. **Private DNS** - Internal name resolution
4. **Traffic Manager** - Global load balancing and failover
5. **Azure Storage** - Storage accounts, blob containers, and file shares

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