# Lab 05 - Custom Routes with Network Virtual Appliance

This lab demonstrates how to create custom routes to control network traffic flow through a Network Virtual Appliance (NVA).

## What it creates

- Route Table: `publictable`
- Custom Route: Routes traffic from public subnet (10.0.0.0/24) to private subnet (10.0.1.0/24) via NVA (10.0.2.4)
- Virtual Network: `vnet` (10.0.0.0/16)
- Subnets:
  - `publicsubnet` (10.0.0.0/24)
  - `privatesubnet` (10.0.1.0/24) 
  - `dmzsubnet` (10.0.2.0/24)

## Architecture

```
Public Subnet (10.0.0.0/24) → Custom Route → DMZ Subnet (10.0.2.4 NVA) → Private Subnet (10.0.1.0/24)
```

## Deployment

### Terraform
```bash
terraform init
terraform plan
terraform apply
```

### Azure CLI
```bash
az login
./deploy.sh
```

## Cleanup
```bash
terraform destroy
# or
az group delete --name <resource-group-name>
```