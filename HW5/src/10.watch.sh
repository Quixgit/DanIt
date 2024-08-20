#!/bin/bash


WATCH_DIR="$HOME/watch"

# Проверяем, существует ли каталог
if [ ! -d "$WATCH_DIR" ]; then
    echo "Ошибка: Каталог $WATCH_DIR не существует."
    exit 1
fi

# Период проверки в секундах
CHECK_INTERVAL=10

# Храним имена файлов, которые уже обработаны
processed_files=""

while true; do
    # Перебираем все файлы в каталоге
    for NEW_FILE in "$WATCH_DIR"/*; do
        # Проверяем, является ли это файлом и не был ли он уже обработан
        if [ -f "$NEW_FILE" ] && [[ ! "$processed_files" =~ "$NEW_FILE" ]]; then
            echo "Новый файл обнаружен: $NEW_FILE"
            echo "Содержимое файла $NEW_FILE:"
            cat "$NEW_FILE"
            # Переименовываем файл в *.back
            mv "$NEW_FILE" "${NEW_FILE}.back"
            # Добавляем файл в список обработанных
            processed_files+="$NEW_FILE "
        fi
    done
    # Пауза перед следующей проверкой
    sleep "$CHECK_INTERVAL"
done
