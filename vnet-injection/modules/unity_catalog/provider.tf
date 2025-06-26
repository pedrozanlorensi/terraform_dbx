# Required by the module
# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#     }
    
#     databricks = databricks.mws  # Pass root provider to child module

#     azuread = {
#     source  = "hashicorp/azuread"
#     }
#   }
# }

# # In modules/unity_catalog/metastore.tf
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