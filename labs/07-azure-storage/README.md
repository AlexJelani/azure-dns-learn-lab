# Lab 07 - Manage Azure Storage

## Lab Introduction
In this lab you learn to create storage accounts for Azure blobs and Azure files. You learn to configure and secure blob containers. You also learn to use Storage Browser to configure and secure Azure file shares.

**Estimated timing:** 50 minutes

## Lab Scenario
Your organization is currently storing data in on-premises data stores. Most of these files are not accessed frequently. You would like to minimize the cost of storage by placing infrequently accessed files in lower-priced storage tiers. You also plan to explore different protection mechanisms that Azure Storage offers, including network access, authentication, authorization, and replication.

## Architecture
This lab creates:
- Resource Group: `az104-rg7`
- Storage Account with geo-redundant storage
- Blob container with immutable storage policy
- File share with restricted network access
- Virtual network for secure access

## Job Skills
- **Task 1:** Create and configure a storage account
- **Task 2:** Create and configure secure blob storage  
- **Task 3:** Create and configure secure Azure file storage

## 🚀 Quick Start

### Option 1: Terraform
```bash
cd labs/07-azure-storage
terraform init
terraform plan
terraform apply
```

### Option 2: Bicep
```bash
cd labs/07-azure-storage
az deployment group create \
  --resource-group az104-rg7 \
  --template-file main.bicep
```

## What Gets Created

### Storage Account
- **Performance:** Standard
- **Redundancy:** Geo-redundant storage (GRS)
- **Public Access:** Disabled by default
- **Lifecycle Management:** Move to cool storage after 30 days

### Blob Container
- **Name:** `data`
- **Access Level:** Private
- **Immutable Policy:** 180-day retention
- **Access Tier:** Hot

### File Share
- **Name:** `share1`
- **Access Tier:** Transaction optimized
- **Backup:** Disabled

### Network Security
- Virtual network with service endpoints
- Storage account restricted to VNet access
- Client IP allowlist for initial setup

## 🧪 Testing the Lab

1. **Verify Storage Account:**
   ```bash
   az storage account show --name <storage-account-name> --resource-group az104-rg7
   ```

2. **Test Blob Access:**
   - Upload a file to the `data` container
   - Generate SAS token for secure access
   - Verify public access is blocked

3. **Test File Share:**
   - Create directories in `share1`
   - Upload files via Storage Browser
   - Verify network restrictions

## 🔒 Security Features

- **Network Access:** Restricted to virtual network
- **Blob Immutability:** 180-day retention policy
- **Access Control:** Private containers with SAS tokens
- **Encryption:** Default encryption at rest
- **Redundancy:** Geo-redundant storage for disaster recovery

## 💰 Cost Estimation
- Storage Account: ~$0.02/GB/month (Standard GRS)
- Blob Storage: ~$0.018/GB/month (Hot tier)
- File Storage: ~$0.06/GB/month (Transaction optimized)
- Network: Minimal for lab usage

## 🧹 Cleanup
```bash
# Terraform
terraform destroy

# Azure CLI
az group delete --name az104-rg7 --yes --no-wait
```

## 📚 Learn More
- [Azure Storage Account Overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Blob Storage Security](https://docs.microsoft.com/en-us/azure/storage/blobs/security-recommendations)
- [Azure Files](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)