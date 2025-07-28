# Data source to get existing Metastore information when using existing one
data "databricks_metastore" "existing" {
  count        = var.use_existing_metastore ? 1 : 0
  provider     = databricks.mws
  metastore_id = var.existing_metastore_id
}

# Create Metastore on the Databricks Account Console (only if not using existing)
resource "databricks_metastore" "databricks-metastore" {
  count         = var.use_existing_metastore ? 0 : 1
  provider      = databricks.mws
  name          = var.metastore_name
  region        = var.location
  owner         = var.metastore_owner
  force_destroy = true # keep this for the destroy command
}

# Local value to determine which Metastore ID to use
locals {
  metastore_id = var.use_existing_metastore ? var.existing_metastore_id : databricks_metastore.databricks-metastore[0].id
}

# Create a Credential to use for External Locations 
resource "databricks_metastore_data_access" "access-connector-data-access" {
  provider     = databricks.workspace
  depends_on   = [databricks_metastore_assignment.default]
  metastore_id = local.metastore_id
  name         = var.access_connector_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.access_connector.id
  }
  is_default    = true
  force_destroy = true # keep this for the destroy command
}

# Create External Location for the Container
resource "databricks_external_location" "external-location" {
  provider   = databricks.workspace
  depends_on = [databricks_metastore_data_access.access-connector-data-access]
  
  name            = "${var.metastore_storage_name}-external-location"
  url             = format("abfss://%s@%s.dfs.core.windows.net/", 
                           azurerm_storage_container.root_storage_container.name, 
                           azurerm_storage_account.storage_accont.name)
  credential_name = databricks_metastore_data_access.access-connector-data-access.name
  comment         = "External location for Unity Catalog metastore container"
}