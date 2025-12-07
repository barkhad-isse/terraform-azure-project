data "azurerm_client_config" "current" {}

locals {
  # Key Vault name must be 3–24 chars, letters/numbers only, globally unique-ish
  key_vault_name = lower(replace("kv${var.environment}${substr(var.project_name, 0, 8)}", "-", ""))

  # PostgreSQL server name must be globally unique within Azure, letters/numbers/hyphens
  postgres_name = lower(replace("psql-${var.environment}-${substr(var.project_name, 0, 6)}", "-", ""))
}

# Generate a strong password for PostgreSQL admin
resource "random_password" "postgres_admin" {
  length  = 20
  special = true
  # If you wanted custom special characters, you'd use:
  # override_special = "!@#$%^&*()-_=+"
}

# Private DNS zone for PostgreSQL flexible server
resource "azurerm_private_dns_zone" "postgres" {
  name                = "psql-${var.environment}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

# Link DNS zone to the VNet
resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "psql-${var.environment}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = var.vnet_id
}

# Key Vault
resource "azurerm_key_vault" "this" {
  name                        = local.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled  = false
  public_network_access_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover",
      "Backup",
      "Restore",
    ]
  }

  tags = var.tags
}

# Azure Database for PostgreSQL Flexible Server (VNet-injected)
resource "azurerm_postgresql_flexible_server" "this" {
  name                = local.postgres_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version    = var.postgresql_version
  sku_name   = var.postgresql_sku_name
  storage_mb = var.postgresql_storage_mb

  administrator_login    = var.postgresql_admin_username
  administrator_password = random_password.postgres_admin.result

  delegated_subnet_id = var.data_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id
  zone = "1"
  public_network_access_enabled = false

  tags = var.tags
}

# Application database inside the server
resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = var.postgresql_database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Store DB admin password in Key Vault
resource "azurerm_key_vault_secret" "db_admin_password" {
  name         = "postgres-admin-password"
  value        = random_password.postgres_admin.result
  key_vault_id = azurerm_key_vault.this.id
}

# Store connection string in Key Vault
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "postgres-connection-string"
  value        = "postgresql://${var.postgresql_admin_username}:${random_password.postgres_admin.result}@${azurerm_postgresql_flexible_server.this.fqdn}:5432/${var.postgresql_database_name}?sslmode=require"
  key_vault_id = azurerm_key_vault.this.id
}
