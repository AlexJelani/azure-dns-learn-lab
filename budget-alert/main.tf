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

data "azurerm_client_config" "current" {}

resource "azurerm_consumption_budget_subscription" "budget_alert" {
  name            = "100-yen-alert"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  amount     = 100
  time_grain = "Monthly"

  time_period {
    start_date = "2025-01-01T00:00:00Z"
    end_date   = "2025-12-31T23:59:59Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    
    contact_emails = [
      "khali4ever@gmail.com"
    ]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    
    contact_emails = [
      "khali4ever@gmail.com"
    ]
  }
}

output "budget_name" {
  value = azurerm_consumption_budget_subscription.budget_alert.name
}

output "budget_amount" {
  value = "${azurerm_consumption_budget_subscription.budget_alert.amount} yen"
}