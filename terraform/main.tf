resource "azurerm_resource_group" "rg" {
  name     = "redesProyecto"
  location = "East US 2"
}

/*
# 1. Crear todo en Azure y generar el inventory automáticamente
terraform apply

# 2. Esperar ~1 min que las VMs arranquen, luego configurar todo
ansible-playbook -i inventory.ini playbook.yml
*/

#ssh -i C:\Users\Usuario\.ssh\id_rsa azureuser@40.70.188.172
#ssh -i C:\Users\Usuario\.ssh\id_rsa azureuser@20.69.255.109