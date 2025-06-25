resource "databricks_metastore" "databricks-metastore" {
  name          = var.metastore_name
  region        = "centralus"
  owner = "thais.henrique@databricks.com"
  force_destroy = true
}


resource "databricks_metastore_data_access" "access-connector-data-access" {
  metastore_id = databricks_metastore.databricks-metastore.id
  depends_on   = [databricks_metastore_assignment.default, databricks_metastore.databricks-metastore]  # Critical dependency
  name         = var.access_connector_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.access_connector.id
  }
  is_default    = true
  force_destroy = true # keep this for the destroy command
}