################################################
# Terraform and Provider
################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.15.0"
    }
  }
}


# terraform {
#   backend "azurerm" {
#     resource_group_name = "terraform2025"
#     storage_account_name = "terraform2025dev"
#     container_name       = "terraform-state"
#     key                  = "terraform.tfstate"
#   }
# }

provider "azurerm" {
  features {}
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  tenant_id       = var.AZURE_TENANT_ID
}

################################################
# Resource Group (Dev)
################################################
resource "azurerm_resource_group" "terra-rg" {
  name     = var.resource_group_name
  location = "West US"

  tags = {
    Environment = "Dev01-develop"
  }
}

################################################
# AKS Cluster (Dev)
################################################
resource "azurerm_kubernetes_cluster" "terra-aks" {
  name                = azurerm_resource_group.terra-rg.name
  location            = azurerm_resource_group.terra-rg.location
  resource_group_name = azurerm_resource_group.terra-rg.name
  dns_prefix          = "${azurerm_resource_group.terra-rg.name}-aksdeccan"
  kubernetes_version  = "1.30.6"  # example valid version

  default_node_pool {
    name            = "default"
    #node_count      = 3
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = 5
  }

  service_principal {
    client_id     = var.AZURE_CLIENT_ID
    client_secret = var.AZURE_CLIENT_SECRET
  }

  tags = {
    Environment = azurerm_resource_group.terra-rg.name
  }
}

################################################
# Azure Container Registry (Dev)
################################################
# resource "azurerm_container_registry" "terra-acr-dev" {
#   name                = "terraacr2025dev" # unique name
#   resource_group_name = azurerm_resource_group.terra-rg-dev.name
#   location            = azurerm_resource_group.terra-rg-dev.location
#   sku                 = "Standard"
#   admin_enabled       = true

#   tags = {
#     Environment = "Dev"
#   }
# }

################################################
# (Optional) Azure Container Instance
################################################
# resource "azurerm_container_group" "terra-acg-dev" {
#   name                = "terra-acg-dev"
#   location            = azurerm_resource_group.terra-rg-dev.location
#   resource_group_name = azurerm_resource_group.terra-rg-dev.name
#   os_type             = "Linux"

#   container {
#     name   = "terra-acg-dev"
#     image  = "nginx"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 80
#       protocol = "TCP"
#     }
#   }

#   tags = {
#     Environment = "Dev"
#   }
# }

################################################
# Output (kube_config)
################################################
# output "kube_config_dev" {
#   description = "Raw kubeconfig for  AKS cluster"
#   value       = azurerm_kubernetes_cluster.terra-aks-dev.kube_config_raw
#   sensitive   = true
# }