#!/bin/bash


WATCH_DIR="$HOME/watch" #Созданная директория
CHECK=10 #Проверяем каждые 10 сек
PROC="" #Храним информацию которая уже обработана

#Существует ли каталог
if [ ! -d "$WATCH_DIR" ]; then
    echo "Ошибка: Каталог $WATCH_DIR не существует."
    exit 1
fi

while true; do
    #Просматриваем все файлы в директории
    for NEW_FILE in $WATCH_DIR/*; do
        #Является ли это файлом и не был ли он уже обработан
        if [ -f $NEW_FILE ] && [[ ! $PROC =~ $NEW_FILE ]]; then
            echo "Новый файл обнаружен: $NEW_FILE"
            echo "Содержимое файла $NEW_FILE:"
            cat $NEW_FILE
            # Переименовываем файл в *.back
            mv $NEW_FILE ${NEW_FILE}."back"
            # Добавляем файл
            PROC+=$NEW_FILE
        fi
    done
    # Пауза перед следующей проверкой
    sleep $CHECK
done
