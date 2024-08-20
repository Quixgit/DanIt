#!/bin/bash

SOURCE_PATH=$1
DISTANATION_PATH=$2


#Проверяем все ли аргументы переданы
if [ "$#" -ne 2 ]; then
    echo "Не все аргументы переданы в скрипт $0. Необходимо указать исходный path/file, и путь назвачения path/file"
    exit 1
elif [ ! -f $SOURCE_PATH ]; then
    echo "Исходного файла не существует $SOURCE_PATH"
    exit 1

fi

cp $SOURCE_PATH $DISTANATION_PATH
