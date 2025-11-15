###########################################################
# Resource Group module
###########################################################

variable "name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags applied to the RG"
  type        = map(string)
  default     = {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
