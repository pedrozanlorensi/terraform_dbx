# Required by the module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    databricks = {
      source  = "databricks/databricks"  # Explicit source declaration # Recommended version constraint
      configuration_aliases = [databricks.workspace, databricks.mws]
    }
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}