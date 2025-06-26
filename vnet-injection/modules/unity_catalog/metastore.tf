# Create Metastore on the Databricks Account Console
resource "databricks_metastore" "databricks-metastore" {
  name          = var.metastore_name
  region        = var.location
  owner         = var.metastore_owner
  force_destroy = true # keep this for the destroy command
}

# Create a Credential to use for External Locations 
resource "databricks_metastore_data_access" "access-connector-data-access" {
  depends_on   = [databricks_metastore_assignment.default, databricks_metastore.databricks-metastore] # Critical dependency
  metastore_id = databricks_metastore.databricks-metastore.id
  name         = var.access_connector_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.access_connector.id
  }
  is_default    = true
  force_destroy = true # keep this for the destroy command
}