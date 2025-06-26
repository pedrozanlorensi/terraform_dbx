## This outputs are used by the other modules
#  Do not delete them

output "workspace_id" {
  value       = azurerm_databricks_workspace.workspace.workspace_id
  description = "ID of the Databricks workspace"
}

output "workspace_url" {
  value       = azurerm_databricks_workspace.workspace.workspace_url
  description = "URL of the Databricks workspace"
}

output "workspace_resource_id" {
  value       = azurerm_databricks_workspace.workspace.id
  description = "Resource ID on Azure of the Databricks workspace"
}


output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "Name of the Resource Group"
}