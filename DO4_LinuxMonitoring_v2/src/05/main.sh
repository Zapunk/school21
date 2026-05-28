#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Ошибка. Укажите 1 параметр"
    exit 1
elif [[ ! $1 =~ ^[1-4]$ ]]; then
    echo "Ошибка. Укажите 1, 2, 3 или 4"
    exit 1
fi

main() {
    method=$1
    cat ../04/*.log > access.log

    case $method in 
        1)
            awk '{print | "sort -k9,9n"}' access.log ;;
        2)
            awk '{print $1}' access.log | sort -u ;;
        3)
            awk '$9 ~ /^[45][0-9][0-9]$/ {print}' access.log ;;
        4)
             awk '$9 ~ /^[45][0-9][0-9]$/ {print $1}' access.log | sort -u ;;
        *)
            echo "Неправильный выбор метода."
            exit 1
            ;;
    esac
}

main $1