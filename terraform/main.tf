resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    environment = "${var.env}",
    project     = "${var.project}"
  }
}

module "netwrok" {
  source   = "./modules/network"
  prefix   = var.prefix
  env      = var.env
  project  = var.project
  location = azurerm_resource_group.rg.location
  rg-name  = azurerm_resource_group.rg.name
}

module "vm" {
  source    = "./modules/vm"
  prefix    = var.prefix
  env       = var.env
  project   = var.project
  location  = azurerm_resource_group.rg.location
  rg-name   = azurerm_resource_group.rg.name
  subnet-id = module.netwrok.subnet-id
  username  = var.username
}

module "azcr" {
  source   = "./modules/azurecr"
  prefix   = var.prefix
  env      = var.env
  project  = var.project
  location = azurerm_resource_group.rg.location
  rg-name  = azurerm_resource_group.rg.name
}