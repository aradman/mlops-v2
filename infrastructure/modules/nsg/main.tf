# Private endpoint nsg
resource "azurerm_network_security_group" "pe_nsg" {  
  name                = "pe-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Associate private endpoing nsg with private endpoint subnet
resource "azurerm_subnet_network_security_group_association" "pe_nsg" {
  subnet_id                 = var.pe_subnet_id
  network_security_group_id = azurerm_network_security_group.pe_nsg.id

  timeouts {}
}

# Training nsg
resource "azurerm_network_security_group" "training_nsg" {  
  name                = "training-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Associate training nsg with training subnet
resource "azurerm_subnet_network_security_group_association" "training_nsg" {
  subnet_id                 = var.training_subnet_id
  network_security_group_id = azurerm_network_security_group.training_nsg.id

  timeouts {}
}

# Scoring nsg
resource "azurerm_network_security_group" "scoring_nsg" {  
  name                = "scoring-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Associate scoring nsg with scoring subnet
resource "azurerm_subnet_network_security_group_association" "scoring_nsg" {
  subnet_id                 = var.scoring_subnet_id
  network_security_group_id = azurerm_network_security_group.scoring_nsg.id

  timeouts {}
}

# Management nsg
resource "azurerm_network_security_group" "management_nsg" {  
  name                = "management-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


# Inbound Rules
resource "azurerm_network_security_rule" "vm_inbound_bastion" {
  name      = "inbound_rdp_ssh_allow"
  priority  = 110
  direction = "Inbound"
  access    = "Allow"
  protocol  = "*"

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_port_ranges    = ["22", "3389"]
  destination_address_prefix = "*"

  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.management_nsg.name

  depends_on = [
    azurerm_network_security_group.management_nsg
  ]
}

# Associate management nsg with management subnet
resource "azurerm_subnet_network_security_group_association" "management_nsg" {
  subnet_id                 = var.management_subnet_id
  network_security_group_id = azurerm_network_security_group.management_nsg.id

  timeouts {}
}