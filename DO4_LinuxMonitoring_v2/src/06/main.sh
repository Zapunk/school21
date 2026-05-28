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
            goaccess access.log --sort-panel="STATUS_CODE,BY_DATA,ASC" \
            --log-format=COMBINED \
            --no-global-config -a \
            -o report_1.html ;;
        2)
            goaccess access.log --sort-panel="HOSTS,BY_HITS,ASK" \
            --log-format=COMBINED \
            --no-global-config -a \
            -o report_2.html \
            --enable-panel="HOSTS" \
            --ignore-panel=VISITORS \
            --ignore-panel=REQUESTS \
            --ignore-panel=REQUESTS_STATIC \
            --ignore-panel=NOT_FOUND \
            --ignore-panel=HOSTS \
            --ignore-panel=OS \
            --ignore-panel=BROWSERS \
            --ignore-panel=VISIT_TIMES \
            --ignore-panel=VIRTUAL_HOSTS \
            --ignore-panel=REFERRERS \
            --ignore-panel=REFERRING_SITES \
            --ignore-panel=KEYPHRASES \
            --ignore-panel=STATUS_CODES \
            --ignore-panel=REMOTE_USER ;;
        3)
            awk '$9 ~ /^[45][0-9][0-9]$/ {print}' access.log | goaccess \
            --log-format=COMBINED \
            --no-global-config \
            -o report_3.html ;;
        4)
             awk '$9 ~ /^[45][0-9][0-9]$/ {print}' access.log | goaccess \
            --log-format=COMBINED \
            --no-global-config \
            -o report_4.html \
            --enable-panel="HOSTS" \
            --ignore-panel=VISITORS \
            --ignore-panel=REQUESTS \
            --ignore-panel=REQUESTS_STATIC \
            --ignore-panel=NOT_FOUND \
            --ignore-panel=HOSTS \
            --ignore-panel=OS \
            --ignore-panel=BROWSERS \
            --ignore-panel=VISIT_TIMES \
            --ignore-panel=VIRTUAL_HOSTS \
            --ignore-panel=REFERRERS \
            --ignore-panel=REFERRING_SITES \
            --ignore-panel=KEYPHRASES \
            --ignore-panel=STATUS_CODES \
            --ignore-panel=REMOTE_USER ;;
        *)
            echo "Неправильный выбор метода."
            exit 1
            ;;
    esac
}

main $1