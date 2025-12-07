variable "project_name" {
  type        = string
  description = "Base project name used for naming Key Vault and DB."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for security and data resources."
}

variable "location" {
  type        = string
  description = "Azure region for security and data resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc)."
}

variable "vnet_id" {
  type        = string
  description = "ID of the virtual network used for PostgreSQL private DNS link."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to security and data resources."
}

variable "data_subnet_id" {
  type        = string
  description = "Subnet ID for the data tier, used for PostgreSQL flexible server VNet injection."
}

variable "postgresql_version" {
  type        = string
  description = "Version for Azure Database for PostgreSQL flexible server."
}

variable "postgresql_sku_name" {
  type        = string
  description = "SKU name for PostgreSQL flexible server."
}

variable "postgresql_storage_mb" {
  type        = number
  description = "Storage size for PostgreSQL in MB."
}

variable "postgresql_admin_username" {
  type        = string
  description = "Admin username for PostgreSQL flexible server."
}

variable "postgresql_database_name" {
  type        = string
  description = "Name of the main application database."
}
