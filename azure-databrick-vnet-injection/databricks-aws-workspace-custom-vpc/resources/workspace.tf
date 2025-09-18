resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

resource "databricks_mws_storage_configurations" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  storage_configuration_name = "${var.prefix}-storage"
  bucket_name      = aws_s3_bucket.root_storage_bucket.bucket
}

resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${var.prefix}-creds"
  depends_on       = [time_sleep.wait_30_seconds]
}

resource "databricks_mws_workspaces" "this" {
  provider                 = databricks.mws  
  account_id               = var.databricks_account_id
  aws_region               = var.region
  workspace_name           = "${var.prefix}"
  # deployment_name          = "${var.prefix}"
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id
  pricing_tier             = "ENTERPRISE"
  depends_on               = [databricks_mws_networks.this]
}

resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.prefix}-network"
  security_group_ids = try(
    length(var.security_group_ids) > 0 ? var.security_group_ids : [module.vpc[0].default_security_group_id],
    [module.vpc[0].default_security_group_id]
  )  
  subnet_ids = try(
    length(var.subnet_ids) > 0 ? var.subnet_ids :  module.vpc[0].private_subnets)  
  vpc_id = var.vpc_id == "" ? module.vpc[0].vpc_id : var.vpc_id 
}

resource "time_sleep" "wait_2_minutes" {
  depends_on = [databricks_mws_workspaces.this]
  create_duration = "120s"
}

resource "databricks_mws_permission_assignment" "add_admin_group" {
  count = var.metastore_id == "" ? 1 : 0
  provider = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = databricks_group.workspace_admins[0].id
  permissions  = ["ADMIN"]
  depends_on = [databricks_group.workspace_admins, databricks_mws_workspaces.this, time_sleep.wait_2_minutes]
}