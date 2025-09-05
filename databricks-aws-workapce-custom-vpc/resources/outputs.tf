output "workspace_name" {
  description = "The name of the workspace:"
  value       = databricks_mws_workspaces.this.workspace_name
}

output "workspace_url" {
  description = "The URL of the workspace:"
  value       = "https://${databricks_mws_workspaces.this.workspace_name}.cloud.databricks.com"
} 

# output "workspace_tester_notebook_path" {
#   description = "A Workspace Tester notebook has been deployed for your convenience. You can find it at:"
#   value       = databricks_notebook.workspace_tester.path
# }

# Major resource IDs for reuse in further workspaces
output "workspace_id" {
  description = "The ID of the created Databricks workspace"
  value       = databricks_mws_workspaces.this.workspace_id
}

output "metastore_id" {
  description = "The ID of the metastore (created or existing)"
  value       = var.metastore_id == "" ? databricks_metastore.metastore[0].id : var.metastore_id
}

output "vpc_id" {
  description = "The ID of the VPC (created or existing)"
  value       = var.vpc_id == "" ? module.vpc[0].vpc_id : var.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets (created or existing)"
  value       = length(var.subnet_ids) > 0 ? var.subnet_ids : module.vpc[0].private_subnets
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets (created or existing)"
  value       = module.vpc[0].public_subnets
}

output "security_group_id" {
  description = "The ID of the default security group"
  value       = length(var.security_group_ids) > 0 ? var.security_group_ids[0] : module.vpc[0].default_security_group_id
}

output "root_storage_bucket_name" {
  description = "The name of the root storage S3 bucket"
  value       = aws_s3_bucket.root_storage_bucket.bucket
}

output "external_location_bucket_name" {
  description = "The name of the external location S3 bucket"
  value       = aws_s3_bucket.external_location_bucket.bucket
}

output "cross_account_role_arn" {
  description = "The ARN of the cross-account IAM role for Databricks"
  value       = aws_iam_role.cross_account_role.arn
}

output "unity_catalog_role_arn" {
  description = "The ARN of the Unity Catalog IAM role for external data access"
  value       = aws_iam_role.external_data_access.arn
}