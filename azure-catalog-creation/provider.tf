terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "databricks" {
  alias                       = "workspace"
  host                        = var.workspace_host
  azure_workspace_resource_id = var.azure_workspace_resource_id
  auth_type                   = "azure-cli"
}


