## This outputs are used by the other modules
#  Do not delete them

output "metastore_id" {
  value = local.metastore_id
}

output "access_connector_id" {
  value       = azurerm_databricks_access_connector.access_connector.id
  description = "the id of the access connector"
}

output "access_connector_principal_id" {
  value       = azurerm_databricks_access_connector.access_connector.identity[0].principal_id
  description = "The Principal ID of the System Assigned Managed Service Identity that is configured on this Access Connector"
}

output "external_location_name" {
  value       = databricks_external_location.external-location.name
  description = "The name of the external location for the Unity Catalog metastore container"
}

output "external_location_url" {
  value       = databricks_external_location.external-location.url
  description = "The URL of the external location for the Unity Catalog metastore container"
}