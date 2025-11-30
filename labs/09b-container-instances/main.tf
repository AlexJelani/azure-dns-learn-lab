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

resource "azurerm_resource_group" "main" {
  name     = "az104-rg9"
  location = "East US"
}

resource "azurerm_container_group" "main" {
  name                = "az104-c1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "az104-c1-${random_string.dns_suffix.result}"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Environment = "Lab"
    Purpose     = "AZ-104"
  }
}

resource "random_string" "dns_suffix" {
  length  = 8
  special = false
  upper   = false
}

output "container_fqdn" {
  value = azurerm_container_group.main.fqdn
}

output "container_ip" {
  value = azurerm_container_group.main.ip_address
}