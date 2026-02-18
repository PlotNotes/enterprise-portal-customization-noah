terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.name}-rg"
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "./modules/vnet"

  name                = var.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

module "aks" {
  source = "./modules/aks"

  name                = var.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.vnet.aks_subnet_id
  kubernetes_version  = var.kubernetes_version
  vm_size             = var.vm_size
  node_count          = var.node_count
  max_node_count      = var.max_node_count
  tags                = var.tags
}

module "postgresql" {
  source = "./modules/postgresql"

  name                = var.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.vnet.db_subnet_id
  sku_name            = var.db_sku_name
  storage_mb          = var.db_storage_mb
  postgresql_version  = var.db_version
  tags                = var.tags
}
