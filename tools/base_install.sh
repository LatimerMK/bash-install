#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/base_install.sh)

read -p "Вкажіть розмір файлу підкачки 2G: " set_swap_size


# оновити всі пакети до останніх версій:
sudo apt update && sudo apt upgrade -y

# Забезпечте базовий захист від небажаного доступу. Встановіть та налаштуйте ufw (для Ubuntu):
sudo ufw allow OpenSSH
sudo ufw enable

# Налаштування автоматичного оновлення
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Встановлення базових інструментів
sudo apt install git curl wget htop tmux -y

sudo apt install net-tools

# Цей інструмент захищає сервер від спроб перебору паролів через SSH
# для автоматичного блокування зловмисників
sudo apt install fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# встановлення Докера
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker $USER
sudo systemctl status docker
# становлення Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Встановлення файлу підкачки
sudo fallocate -l $set_swap_size /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
