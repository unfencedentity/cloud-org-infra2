# 05 – Core Key Vault

## 1. Overview

The **Azure Key Vault** in the *cloud-org-infra2* platform provides secure storage for:

- Secrets (passwords, API keys, connection strings)
- Certificates
- Encryption keys (future use)

It is deployed as a **core shared service**, available to all future components:  
VMs, App Services, Functions, AKS, Automation, Pipelines, and more.

The Key Vault is created according to enterprise security standards:
- Soft delete enabled (7 days)
- Purge protection enabled
- Standard SKU
- Public network access initially enabled (to simplify early development)
- Consistent naming and tagging
- Standardized resource structure

---

## 2. Resource Details

| Property | Value |
|--------|--------|
| **Name** | `cloudorginfra2devkv` |
| **Type** | Azure Key Vault |
| **Resource Group** | `cloud-org-infra2-dev-rg` |
| **Location** | `westeurope` |
| **SKU** | `standard` |
| **Soft Delete** | Enabled (7 days) |
| **Purge Protection** | Enabled |
| **Public Access** | Enabled (temporary) |
| **Tags** | Standard platform-wide tags |

---

## 3. Terraform Module (infra/modules/key_vault/main.tf)

```hcl
############################################################
# Key Vault module
############################################################

variable "name" {
  type        = string
  description = "Name of the Azure Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group in which the Key Vault will be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault."
  default     = {}
}

# Get current tenant (used for Key Vault tenant_id)
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  public_network_access_enabled = true

  tags = var.tags
}

output "id" {
  value       = azurerm_key_vault.this.id
  description = "ID of the Key Vault."
}

output "name" {
  value       = azurerm_key_vault.this.name
  description = "Name of the Key Vault."
}

output "vault_uri" {
  value       = azurerm_key_vault.this.vault_uri
  description = "Vault URI used by applications."
}
```

---

## 4. Root Module Usage (infra/main.tf)

```hcl
############################################################
# Core Key Vault
############################################################

module "key_vault_core" {
  source = "./modules/key_vault"

  name                = var.key_vault_name
  location            = module.rg_core.location
  resource_group_name = module.rg_core.name

  tags = local.common_tags
}
```

---

## 5. Deployment Outcome

After running `terraform apply`, the following is created:

✔ Fully provisioned Key Vault  
✔ Soft delete & purge protection enabled  
✔ Standard SKU (enterprise-grade)  
✔ Consistent naming convention  
✔ Ready for integration with:
- Virtual Machines  
- Automation Accounts  
- Azure Functions / App Services  
- AKS clusters  
- Private Endpoints (future step)  
- Secret management pipelines  

---

## 6. Summary

The Core Key Vault is now part of the cloud-org-infra2 shared services layer.  
It ensures secure storage of secrets and cryptographic materials for all components that will be added to the platform.

Future improvements:
- Adding Private Endpoint
- Enforcing firewall rules
- Adding Access Policies / RBAC
- Integrating with CI/CD pipelines for automated secret rotation
