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
DESKTOP_FILE="$HOME/.local/share/applications/${NAME}.desktop"

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
