[webservers]
vm-linux1 ansible_host=${ip_linux1} ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa
vm-linux2 ansible_host=${ip_linux2} ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa

[webservers:vars]
ansible_python_interpreter=/usr/bin/python3
