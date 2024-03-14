resource "azurerm_network_interface" "runner_nic" {
  name                = "githubrunner-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "configuration"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.runner_subnet_id
    # public_ip_address_id          = azurerm_public_ip.jumphost_public_ip.id
  }
}

resource "random_password" "runner_password" {
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

resource "azurerm_virtual_machine" "runner" {
  name                  = "githubrunner"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.runner_nic.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "githubrunner"
    admin_username = "azureuser"
    admin_password = random_password.runner_password.result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "githubrunner-osdisk"
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

locals {
  os_profile_with_username = [for vm in azurerm_virtual_machine.runner : vm.os_profile if vm.os_profile.admin_username == "azureuser"]
}

resource "null_resource" "install_powershell" {
  depends_on = [
    azurerm_virtual_machine.runner
  ]
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y wget apt-transport-https software-properties-common",
      "wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb",
      "sudo dpkg -i packages-microsoft-prod.deb",
      "sudo apt-get update",
      "sudo add-apt-repository universe",
      "sudo apt-get update",
      "sudo apt-get install -y powershell"
    ]

  connection {
    type        = "ssh"
    host        = azurerm_network_interface.runner_nic.private_ip_address
    user        = length(local.os_profile_with_username) > 0 ? local.os_profile_with_username[0].admin_username : null
    password    = random_password.runner_password.result
  }
  }
}

resource "null_resource" "install_az_module" {
  depends_on = [
    azurerm_virtual_machine.runner,
    null_resource.install_powershell
  ]
  provisioner "remote-exec" {
    inline = [
      "pwsh -Command 'Install-Module -Name Az -AllowClobber -Scope AllUsers -Force -SkipPublisherCheck'"
    ]
  }

  connection {
    type        = "ssh"
    host        = azurerm_network_interface.runner_nic.private_ip_address
    user        = length(local.os_profile_with_username) > 0 ? local.os_profile_with_username[0].admin_username : null
    password    = random_password.runner_password.result
  }
}

resource "null_resource" "install_runner" {
  depends_on = [
    azurerm_virtual_machine.runner
  ]
  provisioner "remote-exec" {
    inline = [
      # Downloading and configuring GitHub runner
      "mkdir actions-runner && cd actions-runner",
      "curl -O -L https://github.com/actions/runner/releases/download/v2.283.2/actions-runner-linux-x64-2.283.2.tar.gz",
      "tar xzf ./actions-runner-linux-x64-2.283.2.tar.gz",
      "./config.sh --url ${var.repository} --token ${var.access_token} --name ${var.runner_name} --work ./_work",
      "./svc.sh install",
      "./svc.sh start"
    ]
  }

  connection {
    type        = "ssh"
    host        = azurerm_network_interface.runner_nic.private_ip_address
    user        = length(local.os_profile_with_username) > 0 ? local.os_profile_with_username[0].admin_username : null
    password    = random_password.runner_password.result
  }
}

resource "null_resource" "install_az_cli" {
  depends_on = [
    azurerm_virtual_machine.runner
  ]
  provisioner "remote-exec" {
    inline = [
      # Install Azure CLI
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      # Install Azure Machine Learning extension
      "az extension add -n azure-cli-ml"
    ]
  }

  connection {
    type        = "ssh"
    host        = azurerm_network_interface.runner_nic.private_ip_address
    user        = length(local.os_profile_with_username) > 0 ? local.os_profile_with_username[0].admin_username : null
    password    = random_password.runner_password.result
  }
}
