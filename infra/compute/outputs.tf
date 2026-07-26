output "jumpbox_public_ip" {
  description = "Public IP of the jumpbox. SSH entry point for the lab."
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "jumpbox_private_ip" {
  description = "Private IP of the jumpbox inside subnet-mgmt."
  value       = azurerm_network_interface.jumpbox.private_ip_address
}

output "app_public_ip" {
  description = "Public IP of the app VM. Null when app_public_ip_enabled is false."
  value       = var.app_public_ip_enabled ? azurerm_public_ip.app[0].ip_address : null
}

output "app_private_ip" {
  description = "Private IP of the app VM inside subnet-app."
  value       = azurerm_network_interface.app.private_ip_address
}

output "app_url" {
  description = "Browsable URL for the frontend. Null when the app VM has no public IP."
  value       = var.app_public_ip_enabled ? "http://${azurerm_public_ip.app[0].ip_address}:8080" : null
}

output "ssh_jumpbox_command" {
  description = "Ready-to-paste SSH command for the jumpbox."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.jumpbox.ip_address}"
}

output "ssh_app_command" {
  description = "SSH to the app VM by hopping through the jumpbox."
  value       = "ssh -J ${var.admin_username}@${azurerm_public_ip.jumpbox.ip_address} ${var.admin_username}@${var.app_private_ip}"
}
