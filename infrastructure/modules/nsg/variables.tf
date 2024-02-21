variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the Resource Group"
}

variable "pe_subnet_id" {
  type        = string
  description = "Private endpoint subnet id"
}

variable "training_subnet_id" {
  type        = string
  description = "Training subnet id"
}

variable "scoring_subnet_id" {
  type        = string
  description = "Scoring subnet id"
}

variable "management_subnet_id" {
  type        = string
  description = "Management subnet id"
}