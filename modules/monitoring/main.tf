locals {
  law_name = "law-${var.environment}"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.law_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

# VMSS diagnostics (metrics)
resource "azurerm_monitor_diagnostic_setting" "vmss" {
  name                       = "diag-vmss-${var.environment}"
  target_resource_id         = var.vmss_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Load Balancer diagnostics (metrics)
resource "azurerm_monitor_diagnostic_setting" "lb" {
  name                       = "diag-lb-${var.environment}"
  target_resource_id         = var.lb_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Key Vault diagnostics (logs + metrics)
resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "diag-kv-${var.environment}"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# NSG diagnostics – Web NSG
resource "azurerm_monitor_diagnostic_setting" "nsg_web" {
  name                       = "diag-nsg-web-${var.environment}"
  target_resource_id         = var.web_nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

# NSG diagnostics – App NSG
resource "azurerm_monitor_diagnostic_setting" "nsg_app" {
  name                       = "diag-nsg-app-${var.environment}"
  target_resource_id         = var.app_nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

# NSG diagnostics – DB NSG
resource "azurerm_monitor_diagnostic_setting" "nsg_db" {
  name                       = "diag-nsg-db-${var.environment}"
  target_resource_id         = var.db_nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}
