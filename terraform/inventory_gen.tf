# Este archivo genera el inventory.ini de Ansible automáticamente
# después de que terraform apply crea las VMs con sus IPs nuevas

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    ip_linux1 = azurerm_public_ip.pip_linux1.ip_address
    ip_linux2 = azurerm_public_ip.pip_linux2.ip_address
  })

  # Escribe el inventory.ini directamente en la carpeta de Ansible
  filename = "${path.module}/../ansible/inventory.ini"

  depends_on = [
    azurerm_linux_virtual_machine.vm_linux1,
    azurerm_linux_virtual_machine.vm_linux2
  ]
}
