# scoring NSG

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

# Associate scoring NSG with scoring subnet

resource "azurerm_subnet_network_security_group_association" "scoring_nsg" {
  subnet_id                 = var.scoring_subnet_id
  network_security_group_id = azurerm_network_security_group.scoring_nsg.id

  timeouts {}
}

# training NSG
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

# Associate scoring NSG with scoring subnet

resource "azurerm_subnet_network_security_group_association" "training_nsg" {
  subnet_id                 = var.training_subnet_id
  network_security_group_id = azurerm_network_security_group.training_nsg.id

  timeouts {}
}
