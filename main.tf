locals {
  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = "${var.project_name}-rg-${var.environment}"

  common_tags = merge(
    {
      environment = var.environment
      project     = var.project_name
    },
    var.tags
  )
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  address_space    = var.address_space
  subnet_prefixes  = var.subnet_prefixes
  allowed_ssh_from = var.allowed_ssh_source_ip

  environment = var.environment
  tags        = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  subnet_id   = module.network.public_subnet_id
  environment = var.environment
  tags        = local.common_tags

  vmss_sku       = var.vmss_sku
  instance_count = var.vmss_instance_count
  instance_min   = var.vmss_instance_min
  instance_max   = var.vmss_instance_max

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
}

module "security" {
  source = "./modules/security"

  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  tags                = local.common_tags

  data_subnet_id            = module.network.data_subnet_id
  postgresql_version        = var.postgresql_version
  postgresql_sku_name       = var.postgresql_sku_name
  postgresql_storage_mb     = var.postgresql_storage_mb
  postgresql_admin_username = var.postgresql_admin_username
  postgresql_database_name  = var.postgresql_database_name
  vnet_id                   = module.network.vnet_id
}

module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  tags                = local.common_tags

  vmss_id      = module.compute.vmss_id
  lb_id        = module.compute.lb_id
  key_vault_id = module.security.key_vault_id

  web_nsg_id = module.network.web_nsg_id
  app_nsg_id = module.network.app_nsg_id
  db_nsg_id  = module.network.db_nsg_id
}
