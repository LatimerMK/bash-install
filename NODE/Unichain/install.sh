#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/NODE/Unichain/install.sh)
set -e  # Зупинити виконання при помилці

# Вивід логотипу
curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/logo.sh | bash
echo "Встановлення Unichain Node!"

# Оновлення системи
sudo apt update && sudo apt upgrade -y

# Встановлення Docker та Docker Compose (якщо закоментоване — можна вручну розкоментувати)
# sudo apt install docker.io
# sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

cd $HOME

# Клонування репозиторію
if [ ! -d "$HOME/unichain-node" ]; then
    git clone https://github.com/Uniswap/unichain-node
else
    echo "Unichain Node вже клоновано."
fi

# Редагування docker-compose.yml
read -p "Натисніть Enter щоб редагувати docker-compose.yml, після завершення натисніть CTRL+X -> Y -> Enter"
nano $HOME/unichain-node/docker-compose.yml
read -p "Натисніть Enter для продовження..."

# Запуск ноди
docker-compose -f $HOME/unichain-node/docker-compose.yml up -d

echo "Тест відгуку Unichain Node!"
curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' \
     -H "Content-Type: application/json" http://localhost:8545

# Вивід приватного ключа
echo "Приватний ключ Unichain Node:"
cat $HOME/unichain-node/geth-data/geth/nodekey
echo

# Дозволяє вставити власний ключ вручну
read -p "Хочете відредагувати приватний ключ? (y/n): " edit_key
if [[ "$edit_key" == "y" ]]; then
    nano $HOME/unichain-node/geth-data/geth/nodekey
    echo "Приватний ключ оновлено."
fi

# Перевірка синхронізації
echo "Перевірка синхронізації..."
sync_status=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[], "id":1}' \
     -H "Content-Type: application/json" http://localhost:8545)
echo "Відповідь від ноди: $sync_status"

if [[ "$sync_status" == *'"result":false'* ]]; then
    echo "Синхронізація завершена!"
else
    echo "Нода ще синхронізується..."
    echo "Команда для перевірки:"
    echo ">>>>>> curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[], "id":1}' -H "Content-Type: application/json" http://localhost:8545"
fi

echo "============================================================="
echo "Logs: docker-compose -f $HOME/unichain-node/docker-compose.yml logs -f --tail=100"
echo "Start: docker-compose -f $HOME/unichain-node/docker-compose up -d"
echo "Restart: docker-compose -f $HOME/unichain-node/docker-compose restart"
echo "Stop: docker-compose -f $HOME/unichain-node/docker-compose down"
echo "Delete node: docker-compose -f $HOME/unichain-node/docker-compose down && sudo rm -r unichain-node"
echo "Test response: curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}'  -H "Content-Type: application/json" http://localhost:8545"
echo "Test sync: curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[], "id":1}' -H "Content-Type: application/json" http://localhost:8545"
echo "============================================================="