resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "root_storage_bucket" {
  bucket        = "${var.resource_prefix}-workspace-root-storage-${random_string.bucket_suffix.result}"
  force_destroy = true
  tags = {
    Name    = "${var.resource_prefix}-workspace-root-storage"
    Owner   = var.client_id
    Project = var.resource_prefix
  }
}

data "databricks_aws_bucket_policy" "this" {
  databricks_e2_account_id = var.databricks_account_id
  bucket                   = aws_s3_bucket.root_storage_bucket.bucket
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket     = aws_s3_bucket.root_storage_bucket.id
  policy     = data.databricks_aws_bucket_policy.this.json

  lifecycle {
    ignore_changes = [policy]
  }
}
