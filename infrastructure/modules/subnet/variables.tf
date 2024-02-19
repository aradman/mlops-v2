variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "subnet_pe_cidr" {
  type        = string
  description = "Private endpoint subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "subnet_training_cidr" {
  type        = string
  description = "Vitural network CIDR"
  default     = "10.0.2.0/24"
}

variable "subnet_scoring_cidr" {
  type        = string
  description = "Vitural network CIDR"
  default     = "10.0.3.0/24"
}