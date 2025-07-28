# Assign Metastore (metastore.tf) to the Workspace (workspace_vnet/workspace.tf)
# Only assign if not skipping assignment (useful if workspace already has a Metastore)
resource "databricks_metastore_assignment" "default" {
  count        = var.skip_metastore_assignment ? 0 : 1
  provider     = databricks.mws
  workspace_id = var.workspace_id
  metastore_id = local.metastore_id
}