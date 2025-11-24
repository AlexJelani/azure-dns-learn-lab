# Free tier version - no deployment slots but works with zero quota
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
  name     = "az104-rg9-free"
  location = "East US"
}

resource "azurerm_service_plan" "main" {
  name                = "asp-free-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "main" {
  name                = "webapp-free-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
  }
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.main.default_hostname}"
}