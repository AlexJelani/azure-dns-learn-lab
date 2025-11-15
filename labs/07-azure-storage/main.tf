terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Use existing Resource Group
data "azurerm_resource_group" "lab" {
  name = "az104-rg7"
}

# Storage Account
resource "azurerm_storage_account" "lab" {
  name                     = "az104storage${random_string.suffix.result}"
  resource_group_name      = data.azurerm_resource_group.lab.name
  location                 = data.azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  
  public_network_access_enabled = true
  
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

# Random suffix for storage account name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Virtual Network
resource "azurerm_virtual_network" "lab" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.lab.location
  resource_group_name = data.azurerm_resource_group.lab.name
}

# Subnet
resource "azurerm_subnet" "lab" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
  
  service_endpoints = ["Microsoft.Storage"]
}

# Storage Account Network Rules (commented out for initial creation)
# resource "azurerm_storage_account_network_rules" "lab" {
#   storage_account_id = azurerm_storage_account.lab.id
#   
#   default_action             = "Deny"
#   virtual_network_subnet_ids = [azurerm_subnet.lab.id]
#   bypass                     = ["AzureServices"]
# }

# Blob Container
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

# File Share
resource "azurerm_storage_share" "share1" {
  name                 = "share1"
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
  access_tier          = "TransactionOptimized"
}

# Storage Management Policy
resource "azurerm_storage_management_policy" "lab" {
  storage_account_id = azurerm_storage_account.lab.id

  rule {
    name    = "movetocool"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
      }
    }
  }
}