
# Create public IPs
resource "azurerm_public_ip" "ip" {
  name                = "${var.prefix}-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.rg-name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${var.prefix}-network-sg"
  location            = "${var.location}"
  resource_group_name = "${var.rg-name}"

  ##TODO put this in a separate file later
  
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-network-interface"
  location            = "${var.location}"
  resource_group_name = "${var.rg-name}"

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = "${var.subnet-id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "${var.prefix}storageaccount"
  resource_group_name      = "${var.rg-name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }
}

# Create (and display) (export to a local file) an SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "keypath" {
    content     = tls_private_key.ssh_key.private_key_pem
    filename = "privatekey.pem"
    file_permission = "0400"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.rg-name}"
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.prefix}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.prefix}-vm"
  admin_username                  = var.username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "${var.env}",
    project = "${var.project}"
  }
}

resource "null_resource" "copy_files" {

  ## Copy files to VM :
  provisioner "file" {
    source = "/Users/zakariaelbazi/Documents/GitHub/zackk8s/kubernetes" #TODO move to variables.
    destination = "/home/azuser"

    connection {
      type = "ssh"
      user = var.username
      host = azurerm_public_ip.ip.ip_address
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm,
  ]
}

resource "null_resource" "install_minikube_script" {

  connection {
      type = "ssh"
      user = var.username
      host = azurerm_public_ip.ip.ip_address
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  ## run installtion script in the vm :
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/azuser/kubernetes/install_minikube.sh"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /home/azuser/kubernetes/install_minikube.sh"
    ] 
  }

  depends_on = [
    null_resource.copy_files,
  ]
}