module "create_workspace_with_vnet" {
  source   = "./modules/workspace_vnet"
  prefix = "${var.prefix}"
  location = "${var.location}"
}

# Create more workspace (dev - stage- prod)
# module "create_workspace_with_vnet" {
#   source   = "./modules/workspace_vnet"
#   prefix = "${var.prefix}"
#   location = "${var.location}"
# }

# Add condition to create or not some resources
module "unity_catalog_setup" {
  source             = "./modules/unity_catalog"
  prefix                      = var.prefix
  metastore_storage_name      = replace("${var.prefix}-mss", "-", "")
  metastore_name              = "${var.prefix}-metastore"
  access_connector_name       = "${var.prefix}-access-connector"
  workspace_id                = module.create_workspace_with_vnet.workspace_id
  resource_group_name         = module.create_workspace_with_vnet.rg_name
  workspace_resource_id       = module.create_workspace_with_vnet.workspace_resource_id
  location                    = var.location
  tags = var.tags
  depends_on = [module.create_workspace_with_vnet]
  providers = {
    databricks = databricks.workspace  # Explicitly pass the provider
  }
}