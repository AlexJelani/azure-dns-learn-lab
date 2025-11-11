# Azure DNS Lab - Terraform Configuration
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

resource "azurerm_resource_group" "rg" {
  name     = "learn-dns-rg"
  location = "japaneast"
}

resource "azurerm_dns_zone" "zone" {
  name                = "wideworldimports111125.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  records             = ["10.10.10.10"]
}

output "name_server" {
  value = tolist(azurerm_dns_zone.zone.name_servers)[0]
}

output "verification_command" {
  value = "nslookup www.wideworldimports111125.com ${tolist(azurerm_dns_zone.zone.name_servers)[0]}"
}