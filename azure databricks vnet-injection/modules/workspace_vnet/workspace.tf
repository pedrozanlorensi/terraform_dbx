# Create Azure Databricks Workspace
resource "azurerm_databricks_workspace" "workspace" {
  name                        = "workspace-${var.prefix}"
  resource_group_name         = azurerm_resource_group.rg.name # (resource_group.tf)
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  public_network_access_enabled = true


  custom_parameters {
    no_public_ip        = true
    
    virtual_network_id  = azurerm_virtual_network.vnet.id # (network.tf)
    public_subnet_name  = azurerm_subnet.public.name # (network.tf)
    private_subnet_name = azurerm_subnet.private.name # (network.tf)
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id # (network.tf)
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id # (network.tf)

    nat_gateway_name = azurerm_nat_gateway.nat_gw.name # (network.tf)
    public_ip_name = azurerm_public_ip.nat_pub_ip.name # (network.tf)
  }

#Optional 
  tags = {
    owner       = "Your_Name" # Example
    Project     = "Terraform Azure" # Example
  }
}