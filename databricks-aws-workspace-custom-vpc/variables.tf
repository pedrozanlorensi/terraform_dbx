variable "databricks_account_id" {
  description = "Databricks Account ID from your Databricks Account Console"
  type        = string
  sensitive = true
}

variable "client_id" {
  description = "Client ID from your user/service principal for Databricks"
  type        = string
  sensitive = true
}

variable "client_secret" {
  description = "Client Secret from your user/service principal for Databricks"
  type        = string
  sensitive = true
}