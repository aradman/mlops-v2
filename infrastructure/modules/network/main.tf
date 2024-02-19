resource "azurerm_virtual_network" "aml_vnet" {
  name                    = "${var.prefix}-vnet-${var.postfix}${var.env}"
  address_space           = ["10.0.0.0/16"]
  location                = var.location
  resource_group_name     = var.rg_name
}

resource "azurerm_subnet" "aml_subnet" {
  name                    = "${var.prefix}-aml-snet-${var.postfix}${var.env}"
  resource_group_name     = var.rg_name
  virtual_network_name    = azurerm_virtual_network.aml_vnet.name
  address_prefixes        = ["10.0.1.0/24"]
  service_endpoints       = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "compute_subnet" {
  name                    = "${var.prefix}-compute-snet-${var.postfix}${var.env}"
  resource_group_name     = var.rg_name
  virtual_network_name    = azurerm_virtual_network.aml_vnet.name
  address_prefixes        = ["10.0.2.0/24"]
  service_endpoints       = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  enforce_private_link_service_network_policies = false
  enforce_private_link_endpoint_network_policies = false
}

resource "azurerm_subnet" "aks_subnet" {
  name                    = "${var.prefix}-aks-snet-${var.postfix}${var.env}"
  resource_group_name     = var.rg_name
  virtual_network_name    = azurerm_virtual_network.aml_vnet.name
  address_prefixes        = ["10.0.3.0/24"]
  service_endpoints       = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                    = "AzureBastionSubnet"
  resource_group_name     = var.rg_name
  virtual_network_name    = azurerm_virtual_network.aml_vnet.name
  address_prefixes        = ["10.0.10.0/27"]
}