output "key_vault_id" {
  description = "ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "postgres_server_id" {
  description = "ID of the PostgreSQL flexible server."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "postgres_server_name" {
  description = "Name of the PostgreSQL flexible server."
  value       = azurerm_postgresql_flexible_server.this.name
}

output "postgres_fqdn" {
  description = "FQDN of the PostgreSQL flexible server."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "postgres_database_name" {
  description = "Name of the PostgreSQL application database."
  value       = azurerm_postgresql_flexible_server_database.app.name
}
