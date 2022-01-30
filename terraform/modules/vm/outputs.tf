output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "ip_address" {
  value     = azurerm_public_ip.ip.ip_address
}

