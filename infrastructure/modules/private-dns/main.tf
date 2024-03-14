resource "azurerm_private_dns_zone" "private_dns_zone_mlw_api" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mlw_api" {
  name                  = "mlops-vnet-aml-api"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_mlw_api.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone" "private_dns_zone_notebook" {
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "notebooks" {
  name                  = "mlops-vnet-notebooks"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_notebook.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone" "private_dns_zone_azuremlcert" {
  name                = "privatelink.cert.api.azureml.ms"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuremlcert" {
  name                  = "mlops-vnet-azuremlcert"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_azuremlcert.name
  virtual_network_id    = var.vnet_id
}

# resource "azurerm_private_dns_zone" "private_dns_zone_kv" {
#   name                = "privatelink.vaultcore.azure.net"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "vaultcore" {
#   name                  = "mlops-vnet-vaultcore"
#   resource_group_name   = var.resource_group_name
#   private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_kv.name
#   virtual_network_id    = var.vnet_id
# }

resource "azurerm_private_dns_zone" "private_dns_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "mlops-vnet-blob"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_blob.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone" "private_dns_zone_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "file" {
  name                  = "mlops-vnet-file"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_file.name
  virtual_network_id    = var.vnet_id
}

# resource "azurerm_private_dns_zone" "private_dns_zone_acr" {
#   name                = "privatelink.azurecr.io"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
#   name                  = "mlops-vnet-acr"
#   resource_group_name   = var.resource_group_name
#   private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_acr.name
#   virtual_network_id    = var.vnet_id
# }
