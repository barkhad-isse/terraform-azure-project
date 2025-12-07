output "resource_group_name" {
  description = "Name of the resource group for this environment."
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Azure region of the resource group."
  value       = azurerm_resource_group.main.location
}

output "environment" {
  description = "Deployment environment."
  value       = var.environment
}

output "project_name" {
  description = "Project base name."
  value       = var.project_name
}
