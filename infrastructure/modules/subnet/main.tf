resource "azurerm_subnet" "training_subnet" {
  name                                           = "snet-private-endpoint"
  resource_group_name                            = var.rg_name  
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.subnet_pe_cidr]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "management_subnet" {
  name                                           = "snet-training"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.subnet_training_cidr]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "management_subnet" {
  name                                           = "snet-scoring"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.subnet_scoring_cidr]
  enforce_private_link_endpoint_network_policies = true
}

