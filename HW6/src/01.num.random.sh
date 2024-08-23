#!/bin/bash

ATTEMPT=0
MIN_NUM=1
MAX_NUM=100


RANGE=$((RANDOM % MAX_NUM+MIN_NUM))
echo "Напишите число от" $MIN_NUM "до" $MAX_NUM

while [ $ATTEMPT -lt 5 ]; do
    ATTEMPT=$((ATTEMPT + 1))
    read -p "Попытка $ATTEMPT укажите число: " NUM
    if [ $NUM -eq $RANGE ]; then
        echo "Вы угадали"
        exit 0
    elif [ $NUM -lt $RANGE ] || [ $NUM -gt $RANGE ]; then
        echo "Вы не угадали ..."
    fi

done
echo "Извините у вас закончились попытки, вы использовали 5 из 5, правильное число" $RANGE.
