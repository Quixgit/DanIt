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
        echo "Вы молодец, угадали"
        exit 0
    elif [ $NUM -lt $RANGE ]; then
            echo "Слишком низко. Попробуйте еще раз."
    else 
	    echo "Слишком высоко. Попробуйте еще раз."
    fi

done
echo "Вы использовали 5 из 5 попыток, правильное число" $RANGE.
