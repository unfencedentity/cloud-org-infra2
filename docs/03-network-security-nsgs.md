# 03 – Network Security Groups (NSGs)

## Overview
This document describes the Network Security Groups (NSGs) used in the cloud-org-infra2 project.
Each subnet in the core virtual network has a dedicated NSG associated with it to provide isolation and a clear security boundary.

At this stage, NSGs are created and associated, but no custom rules are defined yet – only the default Azure rules apply.
Custom rules will be added in later iterations.

---

## 1. NSG Design

All NSGs are deployed in the same Resource Group and region as the VNet:

- Resource Group: cloud-org-infra2-dev-rg
- Location: westeurope

Each subnet has its own NSG:

| Subnet         | NSG Name                           | Purpose                               |
|----------------|-------------------------------------|----------------------------------------|
| snet-mgmt      | cloud-org-infra2-dev-mgmt-nsg       | Management / admin traffic             |
| snet-workload  | cloud-org-infra2-dev-workload-nsg   | Application workloads                  |
| snet-data      | cloud-org-infra2-dev-data-nsg       | Data-related resources                 |
| snet-private   | cloud-org-infra2-dev-private-nsg    | Private endpoints and PaaS services    |

---

## 2. Terraform Module

### 2.1 – NSG module (infra/modules/nsg/main.tf)

############################################################
# NSG module
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

---

## 3. NSG Usage in Root Module (infra/main.tf)

### 3.1 – Management Subnet NSG

module "nsg_mgmt" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-mgmt-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-mgmt"

  tags = local.common_tags
}

### 3.2 – Workload Subnet NSG

module "nsg_workload" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-workload-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-workload"

  tags = local.common_tags
}

### 3.3 – Data Subnet NSG

module "nsg_data" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-data-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-data"

  tags = local.common_tags
}

### 3.4 – Private Subnet NSG

module "nsg_private" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-private-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-private"

  tags = local.common_tags
}

---

## 4. Deployment

Run from the infra/ directory:

terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

Result:

- 4 NSGs created
- 4 subnet → NSG associations created

---

## 5. Next Steps

At this stage, NSGs are present but contain only default rules.

Future iterations will include:

- Inbound management rules for snet-mgmt  
- East–West traffic restrictions between subnets  
- Outbound internet restriction for snet-data and snet-private  
- Integration with Firewall or Azure Bastion (optional)

