#!/bin/bash
readonly localDir="./src"
readonly nameArhive="backup_$(date +%Y:%m:%d:%H).tar.gz"

function creatArhive(){
    echo "Создаем архив из директории "
    
    zip -r "$localDir/$nameArhive"  "$localDir"
    if [ $? -ne 0 ]; then
        echo "Архив не удалось создать"
        exit 1
    fi
}

creatArhive