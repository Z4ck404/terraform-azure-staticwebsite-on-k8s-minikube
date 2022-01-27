variable "prefix" {
  type = string 
}
variable "env" {
  type = string
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
variable "subnet-id" {
  type = string
}
variable "username" {
  type = string
  default = "azuser"
}