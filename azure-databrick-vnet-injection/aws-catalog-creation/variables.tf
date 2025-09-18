variable "workspace_host" {
  description = "Databricks workspace URL, e.g. https://dbc-xxxxxxxx-xxxx.cloud.databricks.com"
  type        = string
}

variable "client_id" {
  description = "Databricks OAuth client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Databricks OAuth client secret"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region for S3 and IAM"
  type        = string
}

variable "resource_prefix" { description = "Name prefix for resources" type = string }

variable "tags" { description = "Tags for AWS resources" type = map(string) default = {} }

variable "databricks_account_id" { description = "Databricks E2 account id" type = string }

variable "external_bucket_name" { description = "Optional explicit external bucket name" type = string default = "" }

variable "external_location_prefix" { description = "Path prefix in the bucket for the external location" type = string }

variable "external_location_name" { description = "External location name" type = string }

variable "storage_credential_name" { description = "Storage credential name" type = string }

variable "external_location_grants" {
  description = "Optional list of grants on the external location"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "create_catalog" {
  description = "If true, also create a Unity Catalog catalog backed by this external location"
  type        = bool
  default     = false
}

variable "catalog_name" {
  description = "Catalog name (required when create_catalog is true)"
  type        = string
  default     = ""
}

variable "catalog_comment" {
  description = "Optional comment for the catalog"
  type        = string
  default     = ""
}

variable "catalog_grants" {
  description = "Optional list of grants for the catalog"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "set_default_catalog" {
  description = "Whether to set the workspace default catalog to the created catalog"
  type        = bool
  default     = false
}


