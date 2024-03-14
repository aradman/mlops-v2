variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "runner_subnet_id" {
  type        = string
  description = "Management subnet id"
}

variable "repository" {
  description = "The URL of the GitHub repository."
}

variable "access_token" {
  description = "The access token for the GitHub repository."
}

variable "runner_name" {
  description = "The name of the GitHub runner."
}

# variable "key_vault_id" {
#   type        = string
#   description = "Key vault id"
# }