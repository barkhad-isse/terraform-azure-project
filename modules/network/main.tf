locals {
  vnet_name           = "vnet-${var.environment}"
  public_subnet_name  = "snet-public-${var.environment}"
  private_subnet_name = "snet-private-${var.environment}"
  data_subnet_name    = "snet-data-${var.environment}"

  web_nsg_name = "nsg-web-${var.environment}"
  app_nsg_name = "nsg-app-${var.environment}"
  db_nsg_name  = "nsg-db-${var.environment}"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.address_space

  tags = var.tags
}

resource "azurerm_subnet" "public" {
  name                 = local.public_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.subnet_prefixes.public]
}

resource "azurerm_subnet" "private" {
  name                 = local.private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.subnet_prefixes.private]
}

resource "azurerm_subnet" "data" {
  name                 = local.data_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [var.subnet_prefixes.data]

  delegation {
    name = "postgresql-flexible-server-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# NSGs

resource "azurerm_network_security_group" "web" {
  name                = local.web_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "app" {
  name                = local.app_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "db" {
  name                = local.db_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# NSG Rules - Web tier

# Internet -> Web (HTTP)
resource "azurerm_network_security_rule" "web_http_internet" {
  name                        = "allow-http-from-internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = var.subnet_prefixes.public
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}

# Internet -> Web (HTTPS)
resource "azurerm_network_security_rule" "web_https_internet" {
  name                        = "allow-https-from-internet"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = var.subnet_prefixes.public
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}

# Your IP -> Web (SSH)
resource "azurerm_network_security_rule" "web_ssh_admin" {
  name                        = "allow-ssh-from-admin-ip"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.allowed_ssh_from
  destination_address_prefix  = var.subnet_prefixes.public
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}

# NSG Rules - App tier

# Web -> App (example using port 8080 for app backend traffic)
resource "azurerm_network_security_rule" "app_from_web" {
  name                        = "allow-app-from-web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.subnet_prefixes.public
  destination_address_prefix  = var.subnet_prefixes.private
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

# NSG Rules - DB tier

# App -> DB (PostgreSQL 5432)
resource "azurerm_network_security_rule" "db_from_app" {
  name                        = "allow-postgres-from-app"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = var.subnet_prefixes.private
  destination_address_prefix  = var.subnet_prefixes.data
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db.name
}


# NSG Associations

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.db.id
}
