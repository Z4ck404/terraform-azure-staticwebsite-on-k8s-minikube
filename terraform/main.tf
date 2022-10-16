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

resource "null_resource" "docker-build" {
  provisioner "local-exec" {
    command = "cd .. && make build"
  }
  provisioner "local-exec" {
    command = "cd .. && make push"
  }
  depends_on = [
    module.azcr
  ]
}

data "external" "kubesecret" {
  program = [var.secret_acr_script_path]
}

module "provisionner-1" {
  source          = "./modules/provisioner"
  prefix          = var.prefix
  docker-username = data.external.kubesecret.result.docker_username
  docker-password = data.external.kubesecret.result.docker_password
  username        = var.username
  ip_address      = module.vm.ip_address
  tls_private_key = module.vm.tls_private_key

  depends_on = [
    module.vm,
    data.external.kubesecret
  ]
}