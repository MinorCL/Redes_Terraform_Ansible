# -----------------------------
# Public IPs
# -----------------------------
resource "azurerm_public_ip" "pip_linux1" {
  name                = "pip-linux1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_linux2" {
  name                = "pip-linux2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# -----------------------------
# Network Interfaces
# -----------------------------
resource "azurerm_network_interface" "nic_linux1" {
  name                = "nic-linux1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_linux1.id
  }
}

resource "azurerm_network_interface" "nic_linux2" {
  name                = "nic-linux2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_linux2.id
  }
}

# -----------------------------
# Linux VM 1
# -----------------------------
resource "azurerm_linux_virtual_machine" "vm_linux1" {
  name                = "vm-linux1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size = "Standard_D2s_v3"

  admin_username = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic_linux1.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Usuario/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# -----------------------------
# Linux VM 2
# -----------------------------
resource "azurerm_linux_virtual_machine" "vm_linux2" {
  name                = "vm-linux2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size = "Standard_D2s_v3"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_linux2.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Usuario/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}