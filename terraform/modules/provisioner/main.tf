
resource "null_resource" "configure-vm" {

  connection {
      type = "ssh"
      user = var.username
      host = var.ip_address
      private_key = var.tls_private_key
    }

  ## Copy files to VM :
  provisioner "file" {
    source = "/Users/zakariaelbazi/Documents/GitHub/zackk8s/kubernetes" #TODO move to variables.
    destination = "/home/${var.username}"
  }

  ## install docker on remote
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod +x /home/${var.username}/get-docker.sh",
      "sh /home/${var.username}/get-docker.sh",
      ## TODO ! The command bellow is a temporary 
      "sudo chmod 666 /var/run/docker.sock" 
    ] 
  }

  ## install & start minikube
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/${var.username}/kubernetes/install_minikube.sh",
      "sh /home/${var.username}/kubernetes/install_minikube.sh",
      "./minikube start --driver=docker"
    ]
  }
}

#uncomment this is you want to automate the build of the docker image
#resource "null_resource" "docker-build-push" { 
#    provisioner "local-exec" {
#      command = "docker build /Users/zakariaelbazi/Documents/GitHub/zackk8s/docker/Dockerfile -t ${var.prefix}.azurecr.io/websites/elbazico:latest"
#  }
#}

#This mean the docker image of the static app is already built and tagged in local
# resource "null_resource" "docker-build-push" { 
#     provisioner "local-exec" {
#       command = "az acr login -n ${var.prefix}"
#     }
#     provisioner "local-exec" {
#       command = "docker push ${var.prefix}.azurecr.io/websites/elbazico:latest"
#     }
# }

resource "null_resource" "configure-vm-1" {
    connection {
      type = "ssh"
      user = var.username
      host = var.ip_address
      private_key = var.tls_private_key
    }
  ## deploy to kubernetes
    provisioner "remote-exec" {
    inline = [
      #TODO move this to a Vault.
     "./kubectl create secret docker-registry acr-secret --docker-server=${var.prefix}.azurecr.io --docker-username=${var.docker-username} --docker-password=${var.docker-password}",
      # create the deloyement
      "./kubectl apply -f /home/${var.username}/kubernetes/deployement.yml",
      #Expose the deployement. #TODO put this in a yaml file.
      "./kubectl expose deployment mywebsite --type=NodePort"
    ]
  }
  depends_on = [
    null_resource.configure-vm
  ]

}