terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"  # You may need to use a more recent version
    }
  }
}

provider "azurerm" {
  subscription_id = "----"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "restricted-rg"
  location = "East US"
}

# Define a Policy restricting allowed VM SKUs to B-series
resource "azurerm_policy_definition" "b_series_only" {
  name         = "b-series-vm-only"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allow Only B-Series VMs"

  policy_rule = <<POLICY
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Compute/virtualMachines"
        },
        {
          "not": {
            "field": "Microsoft.Compute/virtualMachines/sku.name",
            "in": ["Standard_B1ls", "Standard_B1s", "Standard_B2s", "Standard_B2ms", "Standard_B4ms", "Standard_B8ms"]
          }
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY
}

# Assign the policy to the Resource Group
resource "azurerm_resource_group_policy_assignment" "b_series_policy" {
  name                 = "restrict-b-series-vms"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.b_series_only.id
  description          = "Restricts VM deployment to only B-Series SKUs."
}
