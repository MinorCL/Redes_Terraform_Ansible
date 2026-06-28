output "ip_vm_linux1" {
  description = "IP pública de vm-linux1"
  value       = azurerm_public_ip.pip_linux1.ip_address
}

output "ip_vm_linux2" {
  description = "IP pública de vm-linux2"
  value       = azurerm_public_ip.pip_linux2.ip_address
}
