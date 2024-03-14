locals {
  tags = {
    Owner       = "mlops-v2"
    Project     = "mlops-v2"
    Environment = "${var.environment}"
    Toolkit     = "terraform"
    Name        = "${var.prefix}"
  }

  virtual_network = var.enable_vnet_isolation ? module.virtual_network[0] : null
  private_dns     = var.enable_vnet_isolation ? module.private_dns[0] : null
  key_vault       = module.key_vault
}
