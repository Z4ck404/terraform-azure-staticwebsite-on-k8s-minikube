variable "prefix" {
  type = string
  default = "azuser"
}

variable "username" {
  type = string
  default = "azuser"
}

variable "ip_address" {
  type = string
}

variable "tls_private_key" {
  type = string
  sensitive = true
}

#TODO this to move to a vault.
variable "docker-username" {
  type = string
  default = "azuser"
  sensitive = true
}
variable "docker-password" {
  type = string
  default = "azuser"
  sensitive = true
}