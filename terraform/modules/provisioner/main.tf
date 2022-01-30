resource "null_resource" "copy_files" {

  ## Copy files to VM :
  provisioner "file" {
    source = "/Users/zakariaelbazi/Documents/GitHub/zackk8s/kubernetes" #TODO move to variables.
    destination = "/home/${var.username}"

    connection {
      type = "ssh"
      user = var.username
      host = var.ip_address
      private_key = var.tls_private_key
    }
  }

}

resource "null_resource" "install_minikube_script" {

  connection {
      type = "ssh"
      user = var.username
      host = var.ip_address
      private_key = var.tls_private_key
    }
  ## install docker on remote
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod +x /home/${var.username}/get-docker.sh",
      "sh /home/${var.username}/get-docker.sh",
      ## TODO ! The command bellow is a temporary fix
      "sudo chmod 666 /var/run/docker.sock" 
    ] 
  }
  ## install minikube
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/${var.username}/kubernetes/install_minikube.sh",
      "sh /home/${var.username}/kubernetes/install_minikube.sh"
    ]
  }

   provisioner "remote-exec" {
    inline = [
      "./minikube start --driver=docker"
    ]
  }

  depends_on = [
    null_resource.copy_files,
  ]
}