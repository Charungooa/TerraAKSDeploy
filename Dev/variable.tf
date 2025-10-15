################################################
# Variables
################################################
variable "AZURE_CLIENT_ID" {
  type        = string
  description = "Azure AD Application client ID"
}

variable "AZURE_CLIENT_SECRET" {
  type        = string
  description = "Azure AD Application client secret"
  sensitive   = true
}

variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure subscription ID"
}

variable "AZURE_TENANT_ID" {
  type        = string
  description = "Azure tenant ID"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
  default     = "terra-rg-00"
}

variable "azurerm_container_registry_name" {
  type        = string
  description = "Name of the Azure Container Registry"
  default     = "terraacr2025dev" # must be globally unique
  
}