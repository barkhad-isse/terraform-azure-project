variable "resource_group_name" {
  type        = string
  description = "Resource group for monitoring resources."
}

variable "location" {
  type        = string
  description = "Azure region for monitoring resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, prod, etc)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to monitoring resources."
}

variable "vmss_id" {
  type        = string
  description = "ID of the VM scale set to monitor."
}

variable "lb_id" {
  type        = string
  description = "ID of the Load Balancer to monitor."
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault to monitor."
}

variable "web_nsg_id" {
  type        = string
  description = "ID of the web NSG to monitor."
}

variable "app_nsg_id" {
  type        = string
  description = "ID of the app NSG to monitor."
}

variable "db_nsg_id" {
  type        = string
  description = "ID of the db NSG to monitor."
}
