resource "azurerm_subnet" "pe_subnet" {
  name                                           = "snet-private-endpoint"
  resource_group_name                            = var.rg_name  
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.pe_subnet_cidr]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "training_subnet" {
  name                                           = "snet-training"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.training_subnet_cidr]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "scoring_subnet" {
  name                                           = "snet-scoring"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.scoring_subnet_cidr]
  enforce_private_link_endpoint_network_policies = true
}

