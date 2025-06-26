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