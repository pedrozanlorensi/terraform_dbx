# Create a Security Group
resource "azurerm_network_security_group" "sec_group" {
  name                = "${var.prefix}-databricks-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate the Security Group to the Public Subnet (network.tf)
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.sec_group.id
}

# Associate the Security Group to the Private Subnet (network.tf)
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.sec_group.id
}