data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me"
}

locals {
  safe_prefix  = replace(var.prefix, "-", "")
  safe_postfix = replace(var.postfix, "-", "")
}

resource "azurerm_storage_account" "st" {
  name                     = "st${local.safe_prefix}${local.safe_postfix}${var.env}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = var.hns_enabled

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
  
}

resource "azurerm_private_endpoint" "storage_account_blob_private_endpoint_with_dns" {
  name                = "${azurerm_storage_account.st.name}-blob-plink"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_storage_account.st.name}-blob-plink-conn"
    private_connection_resource_id = azurerm_storage_account.st.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "privatednszonegroupstorage"
    private_dns_zone_ids = [var.private_dns_zone_blob_id]
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "storage_account_file_private_endpoint_with_dns" {
  name                = "${azurerm_storage_account.st.name}-file-plink"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${azurerm_storage_account.st.name}-file-plink-conn"
    private_connection_resource_id = azurerm_storage_account.st.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "privatednszonegroupstorage"
    private_dns_zone_ids = [var.private_dns_zone_file_id]
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# # Virtual Network & Firewall configuration

# resource "azurerm_storage_account_network_rules" "firewall_rules" {
#   storage_account_id = azurerm_storage_account.blob.id

#   default_action             = "Allow"
#   ip_rules                   = [] # [data.http.ip.body]
#   virtual_network_subnet_ids = var.firewall_virtual_network_subnet_ids
#   bypass                     = var.firewall_bypass
# }
