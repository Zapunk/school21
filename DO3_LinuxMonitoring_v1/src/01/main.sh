#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Некорректный ввод"
    exit 1
fi

input=$1

if [[ $input =~ ^-?[0-9]+([.,][0-9]+)?$ ]]; then
    echo "Некорректный ввод"
    exit 1
else
    echo "$input"
fi
