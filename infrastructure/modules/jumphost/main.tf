resource "azurerm_network_interface" "jumphost_nic" {
  name                = "jumphost-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "configuration"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.management_subnet_id
    # public_ip_address_id          = azurerm_public_ip.jumphost_public_ip.id
  }
}

resource "random_password" "jumphost_password" {
  length           = 16
  lower            = true
  min_lower        = 1
  upper            = true
  min_upper        = 1
  numeric          = true
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "_%@"
}

resource "azurerm_virtual_machine" "jumphost" {
  name                  = "jumphost"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jumphost_nic.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "dsvm-win-2019"
    sku       = "server-2019"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jumphost"
    admin_username = "azureuser"
    admin_password = random_password.jumphost_password.result
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "jumphost-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# resource "azurerm_key_vault_secret" "jumphost_password" {
#   name         = "jumphost-password"
#   value        = random_password.jumphost_password.result
#   key_vault_id = var.key_vault_id
# }

resource "azurerm_dev_test_global_vm_shutdown_schedule" "jumphost_schedule" {
  virtual_machine_id = azurerm_virtual_machine.jumphost.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "AUS Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}
