variable "prefix" {
  type = string
}
variable "env" {
  type    = string
}
variable "project" {
  type = string
}
variable "location" {
  type = string
}
variable "username" {
  type = string
}
variable "secret_acr_script_path" {
  type = string
  description = "the path to the secret acr script"
  default = "../kubernetes/secret-acr.sh"
}
