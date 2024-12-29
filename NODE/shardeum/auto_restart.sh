#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/NODE/shardeum/auto_restart.sh)

curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/logo.sh | bash


# Перевірка, чи виконується скрипт з правами root
if [ "$(id -u)" -ne 0 ]; then
    echo "Будь ласка, запустіть цей скрипт з правами root."
    exit 1
fi

# Шлях до директорії ноди
SHARDEUM_DIR="$HOME/shardeum"

# Створення скрипта перевірки статусу та перезапуску
CHECK_SCRIPT_PATH="/root/shardeum_auto_restart.sh"
echo "Створюємо скрипт для перевірки та перезапуску..."

cat << 'EOF' > "$CHECK_SCRIPT_PATH"
#!/bin/bash

# Шлях до директорії з нодою
SHARDEUM_DIR="$HOME/shardeum"
CLI_SCRIPT="docker exec shardeum-validator operator-cli"

# Інтервал перевірки в секундах
CHECK_INTERVAL=60

while true; do
    echo "Перевірка статусу ноди..."
    cd $SHARDEUM_DIR

    # Отримання статусу ноди
    STATUS_OUTPUT=$($CLI_SCRIPT status 2>&1)

    # Перевіряємо, чи є статус "stopped"
    if echo "$STATUS_OUTPUT" | grep -q "state: stopped"; then
        echo "Нода зупинена. Виконується перезапуск..."
        $CLI_SCRIPT start 2>&1
        echo "Нода перезапущена. Очікуємо наступну перевірку."
    else
        echo "Нода працює нормально."
    fi

    # Чекаємо перед наступною перевіркою
    sleep $CHECK_INTERVAL
done

EOF

# Налаштування прав на виконання
chmod +x "$CHECK_SCRIPT_PATH"
echo "Скрипт створено та налаштовано для виконання."

# Створення systemd-сервісу
SERVICE_PATH="/etc/systemd/system/shardeum_auto_restart.service"
echo "Створюємо systemd-сервіс..."

cat << EOF > "$SERVICE_PATH"
[Unit]
Description=Автоматична перевірка та перезапуск Shardeum ноди
After=network.target

[Service]
ExecStart=/bin/bash $CHECK_SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Перезапуск системного демона та запуск сервісу
echo "Перезапуск системного демона та запуск сервісу..."
systemctl daemon-reload
systemctl start shardeum_auto_restart.service
systemctl enable shardeum_auto_restart.service

echo "Сервіс успішно створено, запущено та налаштовано для автозапуску."
systemctl status shardeum_auto_restart.service

