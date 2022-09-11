variable "env" {
  type    = string
  default = "demo"
}
variable "project" {
  type = string
}
variable "location" {
  type = string
}
variable "rg-name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_D2_v2"
}