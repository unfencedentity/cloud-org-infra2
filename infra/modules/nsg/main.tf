############################################################
# NSG module
# - Creates a Network Security Group
# - Associates it with a specific subnet
############################################################

variable "name" {
  type        = string
  description = "Name of the Network Security Group."
}

variable "location" {
  type        = string
  description = "Azure region for the NSG."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the NSG will be created."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network that contains the subnet."
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to associate with the NSG."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the NSG."
  default     = {}
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
