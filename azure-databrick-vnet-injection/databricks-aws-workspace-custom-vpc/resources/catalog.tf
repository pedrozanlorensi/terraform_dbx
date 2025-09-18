resource "databricks_catalog" "workspace_catalog" {
  provider = databricks.workspace
  metastore_id = var.metastore_id == "" ? databricks_metastore.metastore[0].id : var.metastore_id
  name = "main_${var.prefix}"
  storage_root = databricks_external_location.external_location.url
  comment = "Default catalog for workspace ${var.prefix}-ws, backed by external location."
  depends_on = [databricks_external_location.external_location]
  force_destroy = true
}

# resource "databricks_schema" "default_schema" {
#   provider = databricks.workspace
#   catalog_name = databricks_catalog.workspace_catalog.name
#   name = "default"
#   comment = "Default schema in main catalog"
#   depends_on = [databricks_catalog.workspace_catalog]
#   force_destroy = true
# }

resource "databricks_grants" "catalog_admin_group" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.workspace
  catalog = databricks_catalog.workspace_catalog.name
  grant {
    principal = databricks_group.workspace_admins[0].display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }
  depends_on = [databricks_catalog.workspace_catalog, databricks_group.workspace_admins]
}

resource "databricks_default_namespace_setting" "this" {
  provider = databricks.workspace
  namespace {
    value = databricks_catalog.workspace_catalog.name
  }
  depends_on = [ databricks_catalog.workspace_catalog]
}

# Disable legacy access (HMS), currently not supported in TF, only in Private Preview
# resource "databricks_disable_legacy_access_setting" "this" {
#   provider = databricks.workspace
#   disable_legacy_access {
#     value = true
#   }
#   depends_on = [databricks_mws_workspaces.this, databricks_default_namespace_setting.this]
# }