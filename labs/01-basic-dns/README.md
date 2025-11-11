# Lab 01: Basic DNS Zone and A Record

Create a basic Azure DNS zone with an A record pointing to a static IP address.

## What it creates

- Resource Group: `learn-dns-rg`
- DNS Zone: `wideworldimports111125.com`
- A Record: `www` → `10.10.10.10`

## Deployment

### Terraform
```bash
cd labs/01-basic-dns
terraform init
terraform apply
```

### Bicep
```bash
cd labs/01-basic-dns
az deployment sub create --location japaneast --template-file main.bicep
```

## Verification
```bash
nslookup www.wideworldimports111125.com <name_server_from_output>
```

## Cleanup
```bash
terraform destroy
# or
az group delete --name learn-dns-rg --yes
```