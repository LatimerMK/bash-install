#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/NODE/elixir/elixir_update.sh)

curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/logo.sh | bash

# Запитуємо ім'я контейнера

read -p "Введіть ім'я Docker-контейнера: " container_name
read -p "Введіть порт ноди сток (17690): " node_port

echo "Інсталюємо докер!"
apt install docker.io -y

docker stop $container_name
docker rm -f $container_name

# Завантаження образу
docker pull elixirprotocol/validator:v3 --platform linux/amd64

echo "Port $node_port"
echo "MM $beneficiary "
echo "Validator name $display_name"
echo "elixir/$env_file"

# Запускаємо Docker-контейнер
sudo docker run -d --env-file "$HOME/elixir/$env_file" --name "$container_name" --platform linux/amd64 --restart always -p "$node_port:$node_port" elixirprotocol/validator:v3

echo "Docker-контейнер $container_name запущено!"

docker logs -f --tail=100 $container_name