terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    databricks = {
      source  = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "${var.subscription_id}" # Required for Azure CLI Authentication
}

provider "azuread" {

}

# Workspace Level provider
provider "databricks" {
  alias                       = "workspace"
  host                        = module.create_workspace_with_vnet.workspace_url
  azure_workspace_resource_id = module.create_workspace_with_vnet.workspace_resource_id
  auth_type = "azure-cli" #using Azure CLI
}

# Databricks Account provider
provider "databricks" {
  alias          = "mws"
  host           = "https://accounts.azuredatabricks.net"
  account_id     = var.adb_account_id
  auth_type      = "azure-cli" #using Azure CLI
}