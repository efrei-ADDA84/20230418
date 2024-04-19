provider "azurerm" {
  features {}
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "ADDA84-CTP"
  virtual_network_name = "network-tp4"
  address_prefixes     = ["10.3.1.0/24"]
  lifecycle {
    ignore_changes = all
    prevent_destroy = true
  }
}

resource "azurerm_public_ip" "my_public_ip" {
  name                = "public-ip-${var.vm_name}"
  location            = var.azure_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "my_interface" {
  name                      = "nic-${var.vm_name}"
  location                  = var.azure_location
  resource_group_name       = var.resource_group_name
  ip_configuration {
    name                          = var.subnet_name
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}

resource "azurerm_virtual_machine" "my_vm" {
  name                  = var.vm_name
  location              = var.azure_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.my_interface.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "osdisk-${var.vm_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = tls_private_key.my_private_ssh.public_key_openssh
    }
  }

  provisioner "local-exec" {
    when    = create
    command = "apt-get update && apt-get install -y python"
  }

}

resource "azurerm_network_security_group" "internal" {
  name                = var.network_name
  location            = var.azure_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "tls_private_key" "my_private_ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "store_private_ssh" {
  filename = "./id_rsa"
  content  = tls_private_key.my_private_ssh.private_key_pem
}
