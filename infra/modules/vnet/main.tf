############################################################
# VNet module
# - Creates a virtual network and multiple subnets
############################################################

variable "name" {
  type        = string
  description = "Name of the virtual network."
}

variable "location" {
  type        = string
  description = "Azure region for the virtual network."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the VNet will be created."
}

variable "address_space" {
  type        = list(string)
  description = "Address space (CIDR blocks) for the VNet."
}

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
  description = "Map of subnet configurations."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VNet and subnets."
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.address_space
  tags          = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets

  name                 = "snet-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "IDs of the created subnets."
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}
