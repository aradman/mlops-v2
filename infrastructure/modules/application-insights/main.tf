resource "azurerm_application_insights" "appi" {
  name                = "appi-${var.prefix}-${var.postfix}${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = var.tags
}
