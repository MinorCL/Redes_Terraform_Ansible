# ☁️ Infraestructura como Código — VMs Linux + Balanceo de Carga (Azure)

Automatización con **Terraform + Ansible** de la parte de infraestructura Linux del proyecto de Comunicaciones y Redes (EIF-208, UNA): aprovisiona dos máquinas virtuales Ubuntu en Azure detrás de un Load Balancer, y las configura como servidores web NGINX con HTTPS (Let's Encrypt) listos para servir tráfico balanceado.

Este repositorio cubre la parte de infraestructura Linux del proyecto (VMs + servidor web + balanceo); el servicio de Active Directory (VM Windows Server) se gestionó por separado.

## 🏗️ Arquitectura

```
                    Internet
                        │
                 Load Balancer (Azure)
                    /        \
          VM Linux #1      VM Linux #2
          (NGINX+HTTPS)    (NGINX+HTTPS)
```

- **Terraform** aprovisiona: grupo de recursos, red virtual y subred, grupo de seguridad de red (NSG) con reglas para SSH y HTTPS, dos VMs Ubuntu 22.04 LTS con IP pública propia, y genera automáticamente el inventario de Ansible con las IPs recién creadas.
- **Ansible** configura cada VM: instala y habilita NGINX, obtiene un certificado SSL con **Certbot/Let's Encrypt**, aplica la configuración de NGINX (HTTPS + redirección automática desde HTTP), configura renovación automática del certificado por cron, y habilita el firewall **UFW** permitiendo solo SSH, HTTP y HTTPS.
- El **Load Balancer** de Azure se configuró para distribuir el tráfico HTTPS entre ambas VMs.

## 🗂️ Estructura del repositorio

```
├── terraform/
│   ├── provider.tf          # Provider de Azure (azurerm)
│   ├── main.tf              # Grupo de recursos
│   ├── network.tf           # Red virtual y subred
│   ├── nsg.tf                # Grupo de seguridad de red (reglas SSH/HTTPS)
│   ├── linux_vms.tf         # Las dos VMs Ubuntu con IP pública
│   ├── outputs.tf           # IPs públicas resultantes
│   ├── inventory_gen.tf     # Genera el inventory.ini de Ansible con las IPs reales
│   └── inventory.tpl        # Plantilla del inventario
└── ansible/
    ├── inventory.ini        # Inventario generado (IPs de las VMs)
    ├── playbook.yml         # NGINX + Certbot + firewall UFW
    └── nginx.conf.j2        # Plantilla de configuración de NGINX (HTTPS)
```

## ▶️ Uso

```bash
# 1. Aprovisionar la infraestructura en Azure y generar el inventario de Ansible
cd terraform
terraform init
terraform apply

# 2. Esperar ~1 minuto a que las VMs arranquen, luego configurar los servidores web
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

> Requiere una cuenta de Azure (`az login`) y una llave SSH configurada (`~/.ssh/id_rsa.pub`) referenciada en `linux_vms.tf`.

## 🎓 Contexto

Parte del proyecto de **Comunicaciones y Redes (EIF-208, UNA)**: sitio web seguro balanceado en la nube con autenticación vía Active Directory. Este repositorio corresponde específicamente a la infraestructura Linux (VMs, red, balanceo) automatizada con Terraform y Ansible.