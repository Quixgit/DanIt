#!/bin/bash
#

echo "Введите текст/Enter text:"
read text
echo "Упс" $text | awk '{for(i=NF;i>0;i--) printf "%s ", $i; print ""}'

