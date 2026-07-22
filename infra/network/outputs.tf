output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.this.name
}

output "mgmt_vnet_id" {
  description = "ID of the management virtual network."
  value       = azurerm_virtual_network.mgmt.id
}

output "app_vnet_id" {
  description = "ID of the application virtual network."
  value       = azurerm_virtual_network.app.id
}

output "mgmt_subnet_id" {
  description = "ID of the management subnet."
  value       = azurerm_subnet.mgmt.id
}

output "app_subnet_id" {
  description = "ID of the application subnet."
  value       = azurerm_subnet.app.id
}

output "mgmt_nsg_id" {
  description = "ID of the management network security group."
  value       = azurerm_network_security_group.mgmt.id
}

output "app_nsg_id" {
  description = "ID of the application network security group."
  value       = azurerm_network_security_group.app.id
}
