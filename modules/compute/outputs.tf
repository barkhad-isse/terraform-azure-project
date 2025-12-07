output "vmss_id" {
  description = "ID of the web VM scale set."
  value       = azurerm_linux_virtual_machine_scale_set.web.id
}

output "vmss_name" {
  description = "Name of the web VM scale set."
  value       = azurerm_linux_virtual_machine_scale_set.web.name
}

output "lb_id" {
  description = "ID of the web load balancer."
  value       = azurerm_lb.web.id
}

output "lb_public_ip" {
  description = "Public IP address of the web load balancer."
  value       = azurerm_public_ip.lb.ip_address
}
