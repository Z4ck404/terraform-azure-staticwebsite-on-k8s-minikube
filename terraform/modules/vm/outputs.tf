output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

#we won't probabaly need it outside the module but better to have it here
output "ip_address" {
  value     = azurerm_public_ip.ip.ip_address
}