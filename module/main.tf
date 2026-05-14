resource "azurerm_network_interface" "main" {
  name                = "${var.component_name}-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          =  "${var.component_name}-nic"
    subnet_id                     = "/subscriptions/cde5241e-289a-449b-b2b7-4efcf2d5c83c/resourceGroups/denmark-east-rg/providers/Microsoft.Network/virtualNetworks/Controller-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.component_name}-vm"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size               = "Standard_B1s"

os_disk {
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

source_image_reference {
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "9-lvm"
  version   = "latest"
}

  admin_password = "DevOps@123456"
  admin_username = "devops"

  disable_password_authentication = false


}

resource "azurerm_dns_a_record" "main" {
  name                = "${var.component_name}-dev"
  zone_name           = "drmohanlearning.online"
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 30
  records             = [azurerm_network_interface.main.private_ip_address]
}

