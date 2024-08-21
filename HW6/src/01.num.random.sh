#!/bin/bash

ATTEMPT=0
MIN_NUM=1
MAX_NUM=100


RANGE=$((RANDOM % 100+1))
echo "Напишите число от" $MIN_NUM "до" $MAX_NUM

while [ $ATTEMPT -lt 5 ]; do
    ATTEMPT=$((ATTEMPT + 1))
    read -p "Попытка наберите $ATTEMPT число: " NUM
    if [ $NUM -eq $RANGE ]; then
        echo "Вы угадали"
        exit 0
    elif [ $NUM -lt $RANGE ] || [ $NUM -gt $RANGE ]; then
        echo "Вы не угадали ..."
    else
        echo "И снова не угадали ..."
    fi

done
echo "вы использовали 5 из 5 попыток, правильное число" $RANGE.
