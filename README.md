# Static app on k8s x Azure.
**Terraform**'ing the deployment of a [static website](https://github.com/Z4ck404/z4ck404.github.io) in **azure** with **kubernetes**.
> Medium articles behind this repo : 
>  - [I deployed my static website with Kubernetes on Azure … because why not!](https://medium.com/aws-tip/i-deployed-my-static-website-with-kubernetes-on-azure-because-why-not-39a501399fd7)
>  - [I deployed my static website with Kubernetes on Azure using Terraform … because why not!](https://medium.com/@zakaria-elbazi/i-deployed-my-static-website-with-kubernetes-on-azure-using-terraform-because-why-not-2cdfe8807ca4)

## Requirements
> Please make sure to do this on local or remote where you want to run the script : 

- Create an an azure account.
- Install azure CLI.
- Install Terraform.
- Install Docker.

## Repo Structure 
```
├── docker
│   └── Dockerfile
├── kubernetes
│   ├── deployement.yml
│   ├── ingress.yml
│   ├── install_minikube.sh
│   ├── secret-acr.sh
│   └── service.yml
└── terraform
    ├── commands-terraform
    ├── main.tf
    ├── modules
    │   ├── azurecr
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── network
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── provisioner
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   └── variables.tf
    │   └── vm
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── provider.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    └── variables.tf
```
- **Docker folder** for the docker file of the static website.
- **Kubernetes folder** : contains k8s deployment and service objects yml files and bash scripts that will be used later by terraform to install minikube and create a Kubernetes secret to connect to azure container registry.
- **terraform folder** : containing our infrastructure's code on azure and it's configuration with terraform provisioner resources .

## Usage

```bash
terraform init
```
then 
```bash
terraform apply
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
