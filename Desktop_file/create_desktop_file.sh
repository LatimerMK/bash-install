#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/LatimerMK/bash-install/refs/heads/main/Desktop_file/create_desktop_file.sh) "My Application" "/path/to/your/executable" "/path/to/your/icon.png"

# Перевірте, чи надано необхідні аргументи
if [ "$#" -ne 3 ]; then
    echo "Використання: $0 <name> <exec_path> <icon_path>"
    exit 1
fi

NAME=$1
EXEC_PATH=$2
ICON_PATH=$3

# Створіть .desktop файл
DESKTOP_FILE="$HOME/.local/share/applications/${NAME// /_}.desktop"  # Заміна пробілів на підкреслення

echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Version=1.0" >> "$DESKTOP_FILE"
echo "Name=${NAME}" >> "$DESKTOP_FILE"
echo "Exec=${EXEC_PATH}" >> "$DESKTOP_FILE"
echo "Icon=${ICON_PATH}" >> "$DESKTOP_FILE"
echo "Terminal=false" >> "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Categories=Utility;" >> "$DESKTOP_FILE"

# Зробіть файл виконуваним
chmod +x "$DESKTOP_FILE"

echo "Файл $DESKTOP_FILE створено успішно!"

# Додаємо додаток до Dock
CURRENT_FAVORITES=$(gsettings get org.gnome.shell favorite-apps)

# Оновлення списку улюблених застосунків
NEW_FAVORITES=$(echo $CURRENT_FAVORITES | sed "s/]\$/,'${NAME// /_}.desktop']/")
gsettings set org.gnome.shell favorite-apps "$NEW_FAVORITES"

echo "Додаток ${NAME} додано до Dock."
