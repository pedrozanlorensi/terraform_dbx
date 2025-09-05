# Variables required by this module

variable "prefix" {
  type        = string
  description = "Prefix for the resources in this module"
}

variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "metastore_storage_name" {
  type        = string
  description = "Name of the storage account for Unity Catalog metastore"
}

variable "access_connector_name" {
  type        = string
  description = "Name of the access connector for Unity Catalog metastore"
}

variable "metastore_name" {
  type        = string
  description = "the name of the metastore"
}

variable "tags" {
  type        = map(string)
  description = "(Required) Map of tags to attach to resources"
}

variable "workspace_id" {
  type        = string
  description = "The ID of Databricks workspace"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "workspace_resource_id" {
  description = "Resource ID of the Databricks workspace"
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