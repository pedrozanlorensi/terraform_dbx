locals {
  bucket_name = var.external_bucket_name != "" ? var.external_bucket_name : "${var.resource_prefix}-extloc-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "external" {
  bucket        = local.bucket_name
  force_destroy = true
  tags          = var.tags
}

data "databricks_aws_bucket_policy" "this" {
  databricks_e2_account_id = var.databricks_account_id
  bucket                   = aws_s3_bucket.external.bucket
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.external.id
  policy = data.databricks_aws_bucket_policy.this.json
  lifecycle { ignore_changes = [policy] }
}

data "aws_caller_identity" "current" {}

locals { uc_iam_role = "${var.resource_prefix}-uc-access" }

resource "databricks_storage_credential" "this" {
  provider = databricks.workspace
  name     = var.storage_credential_name
  aws_iam_role { role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.uc_iam_role}" }
  comment = "Managed by Terraform"
}

data "databricks_aws_unity_catalog_assume_role_policy" "this" {
  provider       = databricks.workspace
  aws_account_id = data.aws_caller_identity.current.account_id
  role_name      = local.uc_iam_role
  external_id    = databricks_storage_credential.this.aws_iam_role[0].external_id
}

data "databricks_aws_unity_catalog_policy" "this" {
  provider       = databricks.workspace
  aws_account_id = data.aws_caller_identity.current.account_id
  bucket_name    = aws_s3_bucket.external.id
  role_name      = local.uc_iam_role
}

resource "aws_iam_policy" "ext_data_access" { policy = data.databricks_aws_unity_catalog_policy.this.json }

resource "aws_iam_role" "ext_data_access" {
  name               = local.uc_iam_role
  assume_role_policy = data.databricks_aws_unity_catalog_assume_role_policy.this.json
}

resource "aws_iam_role_policy_attachment" "ext_data_access" {
  role       = aws_iam_role.ext_data_access.name
  policy_arn = aws_iam_policy.ext_data_access.arn
}

resource "databricks_external_location" "this" {
  provider        = databricks.workspace
  name            = var.external_location_name
  url             = "s3://${aws_s3_bucket.external.id}/${trim(var.external_location_prefix, "/")}/"
  credential_name = databricks_storage_credential.this.id
  comment         = "Managed by Terraform"
  depends_on      = [aws_s3_bucket_policy.this]
}

resource "databricks_grants" "external_location" {
  provider          = databricks.workspace
  count             = length(var.external_location_grants) > 0 ? 1 : 0
  external_location = databricks_external_location.this.id
  dynamic "grant" {
    for_each = var.external_location_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

output "external_location_url" { value = databricks_external_location.this.url }
output "external_location_name" { value = databricks_external_location.this.name }
output "storage_credential_name" { value = databricks_storage_credential.this.name }

# Optional: create catalog backed by the external location
resource "databricks_catalog" "this" {
  count        = var.create_catalog ? 1 : 0
  provider     = databricks.workspace
  name         = var.catalog_name
  comment      = var.catalog_comment != "" ? var.catalog_comment : null
  storage_root = databricks_external_location.this.url
  force_destroy = true
}

resource "databricks_grants" "catalog" {
  count    = var.create_catalog && length(var.catalog_grants) > 0 ? 1 : 0
  provider = databricks.workspace
  catalog  = databricks_catalog.this[0].name
  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

resource "databricks_default_namespace_setting" "default_catalog" {
  count    = var.create_catalog && var.set_default_catalog ? 1 : 0
  provider = databricks.workspace
  namespace { value = var.catalog_name }
  depends_on = [databricks_catalog.this]
}


