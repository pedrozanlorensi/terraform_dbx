variable "workspace_host" {
  description = "Databricks workspace URL, e.g. https://adb-123456789.12.azuredatabricks.net"
  type        = string
}

variable "azure_workspace_resource_id" {
  description = "Azure Resource ID of the Databricks workspace"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID used by the azurerm provider"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group name for storage and access connector"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "access_connector_name" {
  description = "Name for the Databricks Access Connector"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name (must be globally unique)"
  type        = string
}

variable "container_name" {
  description = "Storage container name"
  type        = string
}

variable "external_location_path" {
  description = "Path inside the container for the external location (e.g. 'catalogs/analytics')"
  type        = string
}

variable "external_location_name" {
  description = "Name for the external location"
  type        = string
}

variable "storage_credential_name" {
  description = "Name for the storage credential"
  type        = string
}

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


