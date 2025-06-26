# Pass the Resource Group Information
data "azurerm_resource_group" "this" {
  name  = var.resource_group_name
}

# Create Azure Databricks Access Connector
resource "azurerm_databricks_access_connector" "access_connector" {
  name                = var.access_connector_name
  resource_group_name = var.resource_group_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
}

# Cereate Azure Storage Account
resource "azurerm_storage_account" "storage_accont" {
  name                     = var.metastore_storage_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true # Required - Enable Hierarchical Namespace
}

# Create a Container for the Metastore Root Storage
resource "azurerm_storage_container" "root_storage_container" {
  name                  = "${var.metastore_storage_name}-container"
  storage_account_id    = azurerm_storage_account.storage_accont.id
  container_access_type = "private"
}

## Variable with the Roles we need to add for Azure Databricks Access Connector
#  DOC: Steps 2-4 in https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/azure-managed-identities#--step-2-grant-the-managed-identity-access-to-the-storage-account
locals {
  uc_roles = [
    "Storage Blob Data Contributor",  # Normal data access
    "Storage Queue Data Contributor", # File arrival triggers
    "EventGrid EventSubscription Contributor",
  ]
}

# Assign roles to e Azure Access Connector on the Storage Account -> Access Control (IAM)
resource "azurerm_role_assignment" "role_assign" {
  for_each             = toset(local.uc_roles) # Assign each role on locals{} on the Storage Account
  scope                = azurerm_storage_account.storage_accont.id
  role_definition_name = each.value
  principal_id         = azurerm_databricks_access_connector.access_connector.identity[0].principal_id
}
