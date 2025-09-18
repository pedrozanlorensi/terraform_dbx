locals {
  external_location_url = "abfss://${var.container_name}@${var.storage_account_name}.dfs.core.windows.net/${trim(var.external_location_path, "/")}"
  uc_roles = [
    "Storage Blob Data Contributor",
    "Storage Queue Data Contributor",
    "EventGrid EventSubscription Contributor",
  ]
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_databricks_access_connector" "this" {
  name                = var.access_connector_name
  resource_group_name = var.resource_group_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "access_connector_roles" {
  for_each             = toset(local.uc_roles)
  scope                = azurerm_storage_account.this.id
  role_definition_name = each.value
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}

resource "databricks_storage_credential" "this" {
  provider = databricks.workspace
  name     = var.storage_credential_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }
  comment = "Managed by Terraform"
}

resource "databricks_external_location" "this" {
  provider        = databricks.workspace
  name            = var.external_location_name
  url             = local.external_location_url
  credential_name = databricks_storage_credential.this.id
  comment         = "Managed by Terraform"
  depends_on      = [azurerm_role_assignment.access_connector_roles]
}

resource "databricks_grants" "external_location" {
  provider          = databricks.workspace
  count             = length(var.external_location_grants) > 0 ? 1 : 0
  external_location = databricks_external_location.this.id
  dynamic "grant" {
    for_each = var.external_location_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

output "external_location_url" {
  value = databricks_external_location.this.url
}

output "external_location_name" {
  value = databricks_external_location.this.name
}

output "storage_credential_name" {
  value = databricks_storage_credential.this.name
}

# Optional: create catalog backed by the external location
resource "databricks_catalog" "this" {
  count        = var.create_catalog ? 1 : 0
  provider     = databricks.workspace
  name         = var.catalog_name
  comment      = var.catalog_comment != "" ? var.catalog_comment : null
  storage_root = databricks_external_location.this.url
  force_destroy = true
}

resource "databricks_grants" "catalog" {
  count    = var.create_catalog && length(var.catalog_grants) > 0 ? 1 : 0
  provider = databricks.workspace
  catalog  = databricks_catalog.this[0].name
  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

resource "databricks_default_namespace_setting" "default_catalog" {
  count    = var.create_catalog && var.set_default_catalog ? 1 : 0
  provider = databricks.workspace
  namespace { value = var.catalog_name }
  depends_on = [databricks_catalog.this]
}


