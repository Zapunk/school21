#!/bin/bash

read_log="$(pwd)/../02/info.log"


if [ $# -ne 1 ]; then
    echo "Ошибка. Укажите параметр"
    exit 1
elif [[ ! $1 =~ ^[1-3]$ ]]; then
    echo "Ошибка. Укажите 1, 2 или 3"
    exit 1
fi

deletelog() {
    grep "Файл:" "$read_log" | awk '{print $2}' | xargs rm -f
    grep "Каталог:" "$read_log" | awk '{print $2}' | xargs rm -rf
    > "$read_log"
}

deletetime() {
    echo "Введите время начала (DD.MM.YY HH:MM:SS):"
    read start
    echo "Введите время окончания (DD.MM.YY HH:MM:SS):"
    read end

    sudo find / -type f -newermt "$start" ! -newermt "$end" -delete 2>/dev/null
    sudo find / -type d -empty -delete 2>/dev/null
}

deletemask() {
    echo -e "Введите маску в виде хххх_DDMMYY:\n"
    read mask
    sudo find / -type d -name "$mask" -delete 2>/dev/null
}

main() {
    method=$1

    case $method in 
        1)
            deletelog ;;
        2)
            deletetime ;;
        3)
            deletemask ;;
        *)
            echo "Неправильный выбор метода."
            exit 1
            ;;
    esac
}

main $1