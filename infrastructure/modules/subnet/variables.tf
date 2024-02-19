variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_name" {
  description = "Name of the virtual network"
}

variable "pe_subnet_cidr" {
  type        = string
  description = "Private endpoint subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "training_subnet_cidr" {
  type        = string
  description = "Vitural network CIDR"
  default     = "10.0.2.0/24"
}

variable "scoring_subnet_cidr" {
  type        = string
  description = "Vitural network CIDR"
  default     = "10.0.3.0/24"
}