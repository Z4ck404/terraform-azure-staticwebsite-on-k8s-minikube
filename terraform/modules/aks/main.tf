resource "azurerm_kubernetes_cluster" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg-name
  dns_prefix          = "${var.name}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.env,
    project     = var.project
  }
}
