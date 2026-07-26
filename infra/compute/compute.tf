resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-jumpbox-${var.environment}"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "app" {
  count = var.app_public_ip_enabled ? 1 : 0

  name                = "pip-app-${var.environment}"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "nic-jumpbox-${var.environment}"
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.mgmt_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.jumpbox_private_ip
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }
}

resource "azurerm_network_interface" "app" {
  name                = "nic-app-${var.environment}"
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.app_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.app_private_ip
    public_ip_address_id          = var.app_public_ip_enabled ? azurerm_public_ip.app[0].id : null
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                            = local.jumpbox_name
  location                        = local.location
  resource_group_name             = local.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.jumpbox.id]
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  name                            = local.app_name
  location                        = local.location
  resource_group_name             = local.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.app.id]
  tags                            = var.tags

  # Installs Docker and starts a placeholder container on 8080 so the public
  # endpoint can be verified before the real frontend image is deployed.
  custom_data = base64encode(templatefile("${path.module}/cloud-init-app.yaml", {
    admin_username = var.admin_username
  }))

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
