# Bootstrap & Core Resource Group

## Overview

This document describes the initial bootstrap steps for the `cloud-org-infra2` project and the creation of the core Azure Resource Group using Terraform.

## Azure concepts

- **Tenant**: Azure AD / Entra ID directory that contains users, groups and applications.
- **Subscription**: Billing and isolation boundary for Azure resources. All resources must live in a subscription.
- **Resource Group**: Logical container for related Azure resources inside a subscription.

For this project:

- Tenant: `Default Directory (lucianmicrogmail.onmicrosoft.com)`
- Subscription: `Azure subscription 1`
- Core Resource Group: `cloud-org-infra2-dev-rg` (region: `westeurope`)

## Git & repository bootstrap

1. Created GitHub repository `cloud-org-infra2`.
2. Cloned it locally to `C:\repos\cloud-org-infra2`.
3. Created base folder structure:
   - `infra/` (Terraform configuration)
   - `docs/` (project documentation)
   - `automation/` (future automation and CI/CD scripts)
4. Configured Git user and added `.gitignore` to exclude local Terraform state and `terraform.tfvars`.

## Terraform bootstrap

Files created under `infra/`:

- `providers.tf`  
  - Defines the Terraform and AzureRM provider versions.
  - Configures the AzureRM provider with `skip_provider_registration = true`.

- `variables.tf`  
  - Defines input variables such as `location`, `environment`, `project_name`, and `default_tags`.

- `terraform.tfvars.example`  
  - Example values for the variables. Copied locally to `terraform.tfvars` (not committed).

- `main.tf`  
  - Calls the `resource_group` module to create the core resource group.

- `modules/resource_group/main.tf`  
  - Reusable module that creates a single `azurerm_resource_group`.

## Azure CLI & provider registration

- Installed Azure CLI and logged in with `az login --use-device-code`.
- Selected the subscription `Azure subscription 1`.
- Registered required resource providers (e.g. `Microsoft.Resources`, `Microsoft.Network`, `Microsoft.Storage`).
- Updated the provider configuration to disable automatic provider registration.

## First Terraform deployment

From `infra/`:

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

Result:
Created Resource Group cloud-org-infra2-dev-rg in westeurope with default tags:
project = cloud-org-infra2
owner = lucian
environment = dev
