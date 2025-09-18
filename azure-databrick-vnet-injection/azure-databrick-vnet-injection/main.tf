#This Module Create the workspace and all the Azure infrastructure resources required for the workspace setup with VNET Injection
module "create_workspace_with_vnet" {
  source   = "./modules/workspace_vnet"
  prefix = "${var.prefix}"
  location = "${var.location}"
}

#This modules creates Azure Storage Account, Azure Databricks Access Connector, Metastore and assing the Metastore to the Workspace created above
module "unity_catalog_setup" {
  source                      = "./modules/unity_catalog"
  prefix                      = var.prefix
  metastore_storage_name      = replace("${var.prefix}-mss", "-", "")
  metastore_name              = "${var.prefix}-metastore"
  access_connector_name       = "${var.prefix}-access-connector"
  metastore_owner             = var.metastore_owner
  workspace_id                = module.create_workspace_with_vnet.workspace_id
  resource_group_name         = module.create_workspace_with_vnet.rg_name
  workspace_resource_id       = module.create_workspace_with_vnet.workspace_resource_id
  location                    = var.location
  tags                        = var.tags
  
  # New variables for existing Metastore handling
  use_existing_metastore      = var.use_existing_metastore
  existing_metastore_id       = var.existing_metastore_id
  skip_metastore_assignment   = var.skip_metastore_assignment
  
  depends_on = [module.create_workspace_with_vnet]
  providers = {
    databricks.workspace = databricks.workspace
    databricks.mws       = databricks.mws
  }
}