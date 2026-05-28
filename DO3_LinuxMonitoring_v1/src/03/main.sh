#!/bin/bash

sudo chmod +x *.sh
sudo chmod +x scripts/*.sh

background=(
    ''
    '\e[107m'
    '\e[41m'
    '\e[42m'
    '\e[44m'
    '\e[45m'
    '\e[40m'
)

text=(
    ''
    '\e[37m'
    '\e[31m'
    '\e[32m'
    '\e[34m'
    '\e[35m'
    '\e[30m'
)

reset="\e[0m"

if [[ $# -ne 4 ]]; then
    echo "Ошибка: должно быть 4 параметра."
    exit 1
fi

for color in $1 $2 $3 $4; do
    if [[ $color -lt 1 || $color -gt 6 ]]; then
        echo "Параметры должны быть от 1 до 6!"
        exit 1
    fi
done

if [[ $1 -eq $2 || $3 -eq $4 ]]; then
    echo "Фон и цвет не должны совпадать! Попробуйте ещё раз."
    exit 1
fi

hostname=$(scripts/hostname.sh)
timezone=$(scripts/timezone.sh)
user=$(scripts/user.sh)
os=$(scripts/os.sh)
date=$(scripts/date.sh)
uptime=$(scripts/uptime.sh)
uptime_sec=$(scripts/uptime_sec.sh)
ip=$(scripts/ip.sh)
mask=$(scripts/mask.sh)
gateway=$(scripts/gateway.sh)
ram_total=$(scripts/ram_total.sh)
ram_used=$(scripts/ram_used.sh)
ram_free=$(scripts/ram_free.sh)
space_root=$(scripts/space_root.sh)
space_root_used=$(scripts/space_root_used.sh)
space_root_free=$(scripts/space_root_free.sh)

output="\
${background[$1]}${text[$2]}HOSTNAME ${reset}= ${background[$3]}${text[$4]}$hostname${reset}\n\
${background[$1]}${text[$2]}TIMEZONE ${reset}= ${background[$3]}${text[$4]}$timezone${reset}\n\
${background[$1]}${text[$2]}USER ${reset}= ${background[$3]}${text[$4]}$user${reset}\n\
${background[$1]}${text[$2]}OS ${reset}= ${background[$3]}${text[$4]}$os${reset}\n\
${background[$1]}${text[$2]}DATE ${reset}= ${background[$3]}${text[$4]}$date${reset}\n\
${background[$1]}${text[$2]}UPTIME ${reset}= ${background[$3]}${text[$4]}$uptime${reset}\n\
${background[$1]}${text[$2]}UPTIME_SEC ${reset}= ${background[$3]}${text[$4]}$uptime_sec${reset}\n\
${background[$1]}${text[$2]}IP ${reset}= ${background[$3]}${text[$4]}$ip${reset}\n\
${background[$1]}${text[$2]}MASK ${reset}= ${background[$3]}${text[$4]}$mask${reset}\n\
${background[$1]}${text[$2]}GATEWAY ${reset}= ${background[$3]}${text[$4]}$gateway${reset}\n\
${background[$1]}${text[$2]}RAM_TOTAL ${reset}= ${background[$3]}${text[$4]}$ram_total${reset}\n\
${background[$1]}${text[$2]}RAM_USED ${reset}= ${background[$3]}${text[$4]}$ram_used${reset}\n\
${background[$1]}${text[$2]}RAM_FREE ${reset}= ${background[$3]}${text[$4]}$ram_free${reset}\n\
${background[$1]}${text[$2]}SPACE_ROOT ${reset}= ${background[$3]}${text[$4]}$space_root${reset}\n\
${background[$1]}${text[$2]}SPACE_ROOT_USED ${reset}= ${background[$3]}${text[$4]}$space_root_used${reset}\n\
${background[$1]}${text[$2]}SPACE_ROOT_FREE ${reset}= ${background[$3]}${text[$4]}$space_root_free${reset}"

echo -e "$output"