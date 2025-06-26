# Assign Metastore (metastore.tf) to the Workspace (workspace_vnet/workspace.tf)
resource "databricks_metastore_assignment" "default" {
  workspace_id = var.workspace_id # or other id on the region
  metastore_id = databricks_metastore.databricks-metastore.id
}