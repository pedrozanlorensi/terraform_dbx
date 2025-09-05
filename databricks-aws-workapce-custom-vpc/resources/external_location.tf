# External Location S3 Bucket
resource "random_string" "external_bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "external_location_bucket" {
  bucket        = "${var.resource_prefix}-external-location-${random_string.external_bucket_suffix.result}"
  force_destroy = true
  tags = {
    Name    = "${var.resource_prefix}-external-location"
    Project = var.resource_prefix
  }
}

resource "aws_s3_bucket_versioning" "external_location_bucket_versioning" {
  bucket = aws_s3_bucket.external_location_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

data "databricks_aws_bucket_policy" "external_location" {
  databricks_e2_account_id = var.databricks_account_id
  bucket                   = aws_s3_bucket.external_location_bucket.bucket
}

resource "aws_s3_bucket_policy" "external_location_bucket_policy" {
  bucket = aws_s3_bucket.external_location_bucket.id
  policy = data.databricks_aws_bucket_policy.external_location.json

  lifecycle {
    ignore_changes = [policy]
  }
}

data "aws_caller_identity" "current" {}
locals {
  uc_iam_role = "${var.resource_prefix}-uc-access"
}

resource "databricks_storage_credential" "external" {
  provider = databricks.workspace
  name = "${var.resource_prefix}-external-access"
  //cannot reference aws_iam_role directly, as it will create circular dependency
  aws_iam_role {
    role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.uc_iam_role}"
  }
  comment = "Managed by TF"
  depends_on = [databricks_mws_workspaces.this, databricks_metastore_assignment.this]
}

data "databricks_aws_unity_catalog_assume_role_policy" "this" {
  provider = databricks.workspace
  aws_account_id = data.aws_caller_identity.current.account_id
  role_name      = local.uc_iam_role
  external_id    = databricks_storage_credential.external.aws_iam_role[0].external_id
}

data "databricks_aws_unity_catalog_policy" "this" {
  provider = databricks.workspace
  aws_account_id = data.aws_caller_identity.current.account_id
  bucket_name    = aws_s3_bucket.external_location_bucket.id
  role_name      = local.uc_iam_role
}

resource "aws_iam_policy" "external_data_access" {
  policy = data.databricks_aws_unity_catalog_policy.this.json
}

resource "aws_iam_role" "external_data_access" {
  name                = local.uc_iam_role
  assume_role_policy  = data.databricks_aws_unity_catalog_assume_role_policy.this.json
}

resource "aws_iam_role_policy_attachment" "external_data_access" {
  role       = aws_iam_role.external_data_access.name
  policy_arn = aws_iam_policy.external_data_access.arn
}

resource "databricks_external_location" "external_location" {
  provider        = databricks.workspace
  name            = "${var.resource_prefix}-external-location"
  url             = "s3://${aws_s3_bucket.external_location_bucket.id}/default_catalog/"
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [databricks_storage_credential.external, databricks_mws_workspaces.this, aws_s3_bucket_policy.external_location_bucket_policy]
}

resource "databricks_grants" "external_location_grants" {
  count = var.metastore_id == "" ? 1 : 0
  provider          = databricks.workspace
  external_location = databricks_external_location.external_location.id
  grant {
    principal  = databricks_group.workspace_admins[0].display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }
  depends_on = [databricks_external_location.external_location, databricks_group.workspace_admins] 
}