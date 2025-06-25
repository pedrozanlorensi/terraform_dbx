output "workspace_id" {
  value       = azurerm_databricks_workspace.workspace.workspace_id
  description = "ID of the Databricks workspace"
}

output "workspace_url" {
  value       = azurerm_databricks_workspace.workspace.workspace_url
  description = "ID of the Databricks workspace"
}

output "workspace_resource_id" {
  value       = azurerm_databricks_workspace.workspace.id
  description = "Resource ID of the Databricks workspace"
}


output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "ID of the Databricks workspace"
}