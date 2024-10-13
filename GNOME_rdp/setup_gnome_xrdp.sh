#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/GNOME_rdp/setup_gnome_xrdp.sh)
# Оновлюємо систему
echo "Оновлення системи..."
sudo apt update && sudo apt upgrade

# Встановлення GNOME (ви можете змінити на gnome-session-flashback, якщо це потрібно)
echo "Встановлюємо GNOME..."
sudo apt install ubuntu-gnome-desktop

# Встановлюємо Xrdp
echo "Встановлюємо Xrdp..."
sudo apt install xrdp

# Встановлюємо xfce4
echo "Встановлюємо xfce4..."
sudo apt install xfce4

# Додаємо користувача в групу ssl-cert
echo "Додаємо користувача Xrdp до групи ssl-cert..."
sudo adduser xrdp ssl-cert
sudo adduser root xrdp

# Перезапускаємо Xrdp
echo "Перезапуск Xrdp..."
sudo systemctl restart xrdp

# Перевіряємо статус служби Xrdp
echo "Перевірка статусу Xrdp..."
sudo systemctl status xrdp

# Налаштовуємо GNOME для Xrdp сесій
echo "Налаштовуємо GNOME для Xrdp..."
echo "gnome-session" > ~/.xsession

# Перезапускаємо Xrdp ще раз для застосування змін
echo "Перезапуск Xrdp для застосування налаштувань GNOME..."
sudo systemctl restart xrdp

# Виводимо повідомлення про завершення
echo "Скрипт завершено. Тепер ви можете підключатися до вашого сервера через RDP."
