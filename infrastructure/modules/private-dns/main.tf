resource "azurerm_private_dns_zone" "private_dns_zone_ml_api" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aml" {
  name                  = "mlops-vnet-api"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_ml_api.name
  virtual_network_id    = module.vnet.output.id
}
