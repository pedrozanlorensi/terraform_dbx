# Required by the module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    databricks = {
      source  = "databricks/databricks"  # Explicit source declaration # Recommended version constraint
    }
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}