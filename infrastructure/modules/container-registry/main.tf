locals {
  safe_prefix  = replace(var.prefix, "-", "")
  safe_postfix = replace(var.postfix, "-", "")
}

resource "azurerm_container_registry" "cr" {
  name                = "cr${local.safe_prefix}${local.safe_postfix}${var.env}"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true

  tags = var.tags
}

resource "azurerm_private_endpoint" "container_registry_private_endpoint_with_dns" {
  name                = "${azurerm_container_registry.cr.name}-plink"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_container_registry.cr.name}-plink-conn"
    private_connection_resource_id = azurerm_container_registry.cr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "privatednszonegroupstorage"
    private_dns_zone_ids = [var.private_dns_zone_acr_id]
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
