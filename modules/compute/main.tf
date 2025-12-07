locals {
  vmss_name          = "vmss-web-${var.environment}"
  lb_name            = "lb-web-${var.environment}"
  public_ip_name     = "pip-lb-web-${var.environment}"
  backend_pool_name  = "bepool-web-${var.environment}"
  frontend_name      = "fe-web-${var.environment}"
  probe_name         = "http-probe-${var.environment}"
  lb_rule_name       = "http-rule-${var.environment}"
  vmss_nic_name      = "nic-web-${var.environment}"
  vmss_ipconfig_name = "ipcfg-web-${var.environment}"

  # Simple cloud-init to install and start NGINX
  cloud_init = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
  EOF
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

# Load Balancer
resource "azurerm_lb" "web" {
  name                = local.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = local.frontend_name
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  tags = var.tags
}

# Backend address pool
resource "azurerm_lb_backend_address_pool" "web" {
  name            = local.backend_pool_name
  loadbalancer_id = azurerm_lb.web.id
}

# Health probe on HTTP
resource "azurerm_lb_probe" "http" {
  name            = local.probe_name
  loadbalancer_id = azurerm_lb.web.id
  protocol        = "Tcp"
  port            = var.app_port
}

# Load Balancer rule for HTTP
resource "azurerm_lb_rule" "http" {
  name                           = local.lb_rule_name
  loadbalancer_id                = azurerm_lb.web.id
  protocol                       = "Tcp"
  frontend_port                  = var.app_port
  backend_port                   = var.app_port
  frontend_ip_configuration_name = local.frontend_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
  probe_id                       = azurerm_lb_probe.http.id
}

# VM Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "web" {
  name                = local.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku       = var.vmss_sku
  instances = var.instance_count

  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = local.vmss_nic_name
    primary = true

    ip_configuration {
      name                                  = local.vmss_ipconfig_name
      primary                               = true
      subnet_id                             = var.subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.web.id
      ]
    }
  }

  upgrade_mode = "Rolling"
  health_probe_id = azurerm_lb_probe.http.id

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"
  }

  custom_data = base64encode(local.cloud_init)

  tags = var.tags
}
