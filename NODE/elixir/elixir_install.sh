#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/NODE/elixir/elixir_install.sh)

curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/logo.sh | bash

# Запитуємо ім'я контейнера
read -p "Введіть ім'я Docker-контейнера: " container_name
read -p "Введіть порт ноди сток (17690): " node_port

# Створення директорії elixir, якщо її ще немає
mkdir -p "$HOME/$container_name" && cd "$HOME/$container_name"

# Створюємо файл env з ім'ям контейнера
env_file="${container_name}.env"

# Запитуємо дані у користувача
read -p "Введіть STRATEGY_EXECUTOR_DISPLAY_NAME для $container_name: " display_name
read -p "Введіть STRATEGY_EXECUTOR_BENEFICIARY (адресу гаманця) для $container_name: " beneficiary
read -p "Введіть SIGNER_PRIVATE_KEY для $container_name (без 0x): " private_key

# Записуємо дані у файл env
cat <<EOL > "$env_file"
ENV=prod

STRATEGY_EXECUTOR_DISPLAY_NAME=$display_name
STRATEGY_EXECUTOR_BENEFICIARY=$beneficiary
SIGNER_PRIVATE_KEY=$private_key
EOL

echo "Файл $env_file створено!"

echo "Інсталюємо докер!"
apt install docker.io -y

# Завантаження образу
docker pull elixirprotocol/validator --platform linux/amd64

echo "Port $node_port"
echo "MM $beneficiary "
echo "Validator name $display_name"
echo "elixir/$env_file"

# Запускаємо Docker-контейнер
sudo docker run -d --env-file "$HOME/$container_name/$env_file" --name "$container_name" --platform linux/amd64 --restart always -p "$node_port:17690" elixirprotocol/validator

echo "Docker-контейнер $container_name запущено!"