#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/GNOME_rdp/setup_xrdp.sh)

curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/tools/logo.sh | bash



# Оновлюємо систему
echo "Оновлення системи..."
sudo apt update && sudo apt upgrade -y

# Встановлюємо Xrdp
echo "Встановлюємо Xrdp..."
sudo apt install xrdp -y

# Встановлюємо xfce4
echo "Встановлюємо xfce4..."
sudo apt install xfce4 -y

# Перевіряємо статус служби Xrdp
echo "Перевірка статусу Xrdp..."
sudo systemctl status xrdp

# Функція для вибору робочого столу
choose_desktop() {
  echo "Оберіть робочий стіл для встановлення:"
  echo "1) ubuntu-gnome-desktop"
  echo "2) gnome-session-flashback"
  echo "3) ubuntu-mate-desktop"
  echo "4) xfce4-goodies"
  read -p "Ваш вибір (1/2/3/4): " choice

  case $choice in
    1)
      echo "Встановлюємо GNOME..."
      sudo apt update
      sudo apt install ubuntu-gnome-desktop -y
      sudo dpkg-reconfigure gdm3
      echo "gnome-session" > ~/.xsession
      echo "GNOME успішно встановлено та налаштовано."
      ;;
    2)
      echo "Встановлюємо GNOME..."
      sudo apt update
      sudo apt install gnome-session-flashback -y
      sudo apt install gnome-panel gnome-settings-daemon metacity -y
      echo "gnome-session-flashback" > ~/.xsession
      sudo dpkg-reconfigure gdm3
      echo "GNOME flashback успішно встановлено та налаштовано."
      ;;
    3)
      echo "Встановлюємо MATE..."
      sudo apt update
      sudo apt install ubuntu-mate-desktop -y
      sudo apt install mate-core mate-desktop-environment mate-notification-daemon -y
      echo "mate-session" > ~/.xsession
      sudo dpkg-reconfigure lightdm
      echo "MATE успішно встановлено та налаштовано."
      ;;
    4)
      echo "Встановлюємо XFCE..."
      sudo apt update
      sudo apt install xfce4 xfce4-goodies -y
      echo "xfce4-session" > ~/.xsession
      sudo dpkg-reconfigure gdm3
      echo "XFCE успішно встановлено та налаштовано."
      ;;
    *)
      echo "Невірний вибір. Будь ласка, виберіть 1, 2 або 3."
      choose_desktop  # Якщо вибір невірний, викликаємо функцію знову
      ;;
  esac
}

# Викликаємо функцію
choose_desktop


# Встановлення GNOME (ви можете змінити на gnome-session-flashback, якщо це потрібно)
#echo "Встановлюємо GNOME..."
#sudo apt install ubuntu-gnome-desktop -y
#sudo apt install ubuntu-mate-desktop -y
#sudo apt install xfce4 xfce4-goodies -y

# Налаштовуємо GNOME для Xrdp сесій
#echo "Налаштовуємо GNOME для Xrdp..."
#echo "gnome-session" > ~/.xsession
#echo "mate-session" > ~/.xsession
#echo "xfce4-session" > ~/.xsession

# Перезапускаємо Xrdp ще раз для застосування змін
echo "Перезапуск Xrdp для застосування налаштувань..."
sudo systemctl restart xrdp
echo "Перевірте / встановіть оболочку яка буде запускатись автоматично"
sudo update-alternatives --config x-session-manager

echo "Створення звичайного користувача через якого будемо підключатись"
echo "*потрібно для коректної роботи певних програм"
echo "** натисність Ctrl + C щоб не створювати (всі попередні пункти скріпта вже виконано вдало)"
read -p "Введіть ім'я нового користувача: " new_user
sudo adduser $new_user

# Виводимо повідомлення про завершення
echo "Скрипт завершено. Тепер ви можете підключатися до вашого сервера через RDP."



#якщо замість іконок xrdp буде чорний екран то потрібно в папці /etc/xrdp/ змінити файл
# - sudo nano /etc/xrdp/startwm.sh
# вставивши перед таким рядком( test -x /etc/X11/Xsession && exec /etc/X11/Xsession
#exec /bin/sh /etc/X11/Xsession) наступний текст:
#unset DBUS_SESSION_BUS_ADDRESS
#unset XDG_RUNTIME_DIR



#sudo apt-get purge ubuntu-gnome-desktop gnome-shell gnome-session gnome-control-center gnome-terminal -y
#sudo apt-get purge gnome* -y
#sudo apt-get autoremove --purge -y

#sudo apt-get purge ubuntu-mate-desktop mate-desktop-environment mate-session-manager mate-control-center -y
#sudo apt-get purge mate* -y
#sudo apt-get autoremove --purge -y

#sudo apt-get purge xfce4 xfce4-goodies xfce4-session xfce4-panel -y
#sudo apt-get autoremove --purge -y


#зміна дисплейних пенедженів
#sudo dpkg-reconfigure lightdm
#sudo dpkg-reconfigure gdm3
#rm -rf ~/.cache/sessions/*