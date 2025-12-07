output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "public_subnet_id" {
  description = "ID of the public (web) subnet."
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private (app) subnet."
  value       = azurerm_subnet.private.id
}

output "data_subnet_id" {
  description = "ID of the data (db) subnet."
  value       = azurerm_subnet.data.id
}

output "web_nsg_id" {
  description = "ID of the web tier NSG."
  value       = azurerm_network_security_group.web.id
}

output "app_nsg_id" {
  description = "ID of the app tier NSG."
  value       = azurerm_network_security_group.app.id
}

output "db_nsg_id" {
  description = "ID of the db tier NSG."
  value       = azurerm_network_security_group.db.id
}
