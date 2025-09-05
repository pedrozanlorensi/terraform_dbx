variable "prefix" {
  description = "The Prefix used for all resources in this example"
  type        = string
}

variable "location" {
  description = "Region where the resources will be created"
  type        = string
}


variable "adb_account_id" {
  description = "Databricks Account Console ID"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "(Required) Map of tags to attach to resources"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "metastore_owner" {
  description = "Resource ID of the Databricks workspace"
  type        = string
}

# New variables for handling existing Metastores
variable "use_existing_metastore" {
  type        = bool
  description = "Whether to use an existing Metastore instead of creating a new one"
  default     = false
}

variable "existing_metastore_id" {
  type        = string
  description = "ID of the existing Metastore to use (required when use_existing_metastore is true)"
  default     = ""
}

variable "skip_metastore_assignment" {
  type        = bool
  description = "Whether to skip Metastore assignment (useful if workspace already has a Metastore assigned)"
  default     = false
}