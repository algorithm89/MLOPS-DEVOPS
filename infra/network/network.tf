resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "mgmt" {
  name                = local.mgmt_vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.mgmt_vnet_address_space
  tags                = var.tags
}

resource "azurerm_virtual_network" "app" {
  name                = local.app_vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.app_vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "mgmt" {
  name                 = local.mgmt_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = var.mgmt_subnet_prefixes
}

resource "azurerm_subnet" "app" {
  name                 = local.app_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = var.app_subnet_prefixes
}

resource "azurerm_network_security_group" "mgmt" {
  name                = local.mgmt_nsg_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH-From-Trusted-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_source_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "app" {
  name                = local.app_nsg_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH-From-Mgmt-Subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.mgmt_subnet_prefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-ICMP-From-Mgmt-Subnet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.mgmt_subnet_prefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Frontend-From-Mgmt-Subnet"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefixes    = var.mgmt_subnet_prefixes
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_virtual_network_peering" "mgmt_to_app" {
  name                      = "peer-mgmt-to-app-${var.environment}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.mgmt.name
  remote_virtual_network_id = azurerm_virtual_network.app.id
}

resource "azurerm_virtual_network_peering" "app_to_mgmt" {
  name                      = "peer-app-to-mgmt-${var.environment}"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.app.name
  remote_virtual_network_id = azurerm_virtual_network.mgmt.id
}
