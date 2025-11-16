# 06 – Log Analytics Workspace (LAW)

## 1. Overview

The Log Analytics Workspace is the centralized logging and observability foundation of the cloud-org-infra2 platform. It aggregates logs, metrics, and telemetry from all core Azure services, enabling:

- Kusto Query Language (KQL) analytics
- Dashboards and monitoring
- Azure alerts
- Security investigation and correlation
- Integration with Azure Monitor, Defender for Cloud, Sentinel

At this stage, the workspace is created and ready to receive logs. Diagnostic Settings will be configured later.

---

## 2. Design

Resource Group: cloud-org-infra2-dev-rg  
Location: westeurope  
Workspace Name: cloud-org-infra2-dev-law  
SKU: PerGB2018  
Retention: 30 days  
Purpose: Central logging hub for all foundational services (VNet, NSGs, Key Vault, Storage, etc.)

This workspace is a core shared service for long-term extensibility.

---

## 3. Terraform Implementation

### 3.1 Variables (infra/variables.tf)

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

### 3.2 Values (infra/terraform.tfvars)

log_analytics_workspace_name = "cloud-org-infra2-dev-law"

### 3.3 Module Code (infra/modules/log_analytics/main.tf)

variable "name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "location" {
  description = "Azure region where the workspace will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group where the workspace will be deployed."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the workspace."
  type        = map(string)
  default     = {}
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

output "id" {
  description = "ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Workspace ID used by agents."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "name" {
  description = "Log Analytics workspace name."
  value       = azurerm_log_analytics_workspace.this.name
}

### 3.4 Root Module Usage (infra/main.tf)

module "log_analytics_core" {
  source = "./modules/log_analytics"

  name                = var.log_analytics_workspace_name
  location            = module.rg_core.location
  resource_group_name = module.rg_core.name

  tags = local.common_tags
}

---

## 4. Deployment Outcome

After terraform apply, the following is created:

✔ Fully functional Log Analytics Workspace  
✔ Region: westeurope  
✔ SKU: PerGB2018  
✔ Retention: 30 days  
✔ Standardized tagging  
✔ Ready for diagnostic settings integration  
✔ Backbone for observability and analytics

The workspace is now ready to receive logs from:

- Key Vault
- Storage Account
- NSGs
- Virtual Network / Network Watcher
- Azure Monitor Alerts
- Sentinel (optional in the future)

---

## 5. Summary

The Log Analytics Workspace is the monitoring backbone of the cloud-org-infra2 platform.  
It centralizes logs and metrics, enabling visibility, automation, alerting, and security governance.  
Next step: integrate services with LAW through Diagnostic Settings.
