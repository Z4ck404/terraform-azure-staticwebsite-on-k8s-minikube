
#TODO add encryption to the cr.
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}"
  resource_group_name = var.rg-name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
  georeplications {
    location                = var.location
    zone_redundancy_enabled = false
  }
  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }

}