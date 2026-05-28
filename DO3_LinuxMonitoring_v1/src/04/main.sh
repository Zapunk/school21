#!/bin/bash

sudo chmod +x scripts/*.sh

DEFAULT_COL1_BG=2
DEFAULT_COL1_FONT=3
DEFAULT_COL2_BG=4
DEFAULT_COL2_FONT=5

if [[ -f param.conf ]]; then
    source param.conf
else
    column1_background=$DEFAULT_COL1_BG
    column1_font_color=$DEFAULT_COL1_FONT
    column2_background=$DEFAULT_COL2_BG
    column2_font_color=$DEFAULT_COL2_FONT
fi

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

if [[ ($column1_background -lt 1 || $column1_background -gt 6) ||
      ($column1_font_color -lt 1 || $column1_font_color -gt 6) ||
      ($column2_background -lt 1 || $column2_background -gt 6) ||
      ($column2_font_color -lt 1 || $column2_font_color -gt 6) ]]; then
    echo "Параметры должны быть от 1 до 6"
    exit 1
fi

if [[ $column1_background -eq $column1_font_color ||
      $column2_background -eq $column2_font_color ]]; then
    echo "Фон и цвет не должны совпадать! Измените конфигурацию"
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
${background[$column1_background]}${text[$column1_font_color]}HOSTNAME ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$hostname${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}TIMEZONE ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$timezone${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}USER ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$user${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}OS ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$os${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}DATE ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$date${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}UPTIME ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$uptime${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}UPTIME_SEC ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$uptime_sec${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}IP ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$ip${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}MASK ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$mask${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}GATEWAY ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$gateway${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}RAM_TOTAL ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$ram_total${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}RAM_USED ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$ram_used${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}RAM_FREE ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$ram_free${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}SPACE_ROOT ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$space_root${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}SPACE_ROOT_USED ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$space_root_used${reset}\n\
${background[$column1_background]}${text[$column1_font_color]}SPACE_ROOT_FREE ${reset}= ${background[$column2_background]}${text[$column2_font_color]}$space_root_free${reset}"

echo -e "$output"

echo ""

bg_default_col1=${background[$DEFAULT_COL1_BG]}
txt_default_col1=${text[$DEFAULT_COL1_FONT]}
bg_default_col2=${background[$DEFAULT_COL2_BG]}
txt_default_col2=${text[$DEFAULT_COL2_FONT]}

if [[ $column1_background -eq $DEFAULT_COL1_BG &&
      $column1_font_color -eq $DEFAULT_COL1_FONT &&
      $column2_background -eq $DEFAULT_COL2_BG &&
      $column2_font_color -eq $DEFAULT_COL2_FONT ]]; then
        echo -e "${bg_default_col1}${txt_default_col1}Column 1 background = def>
        echo -e "${txt_default_col1}Column 1 font color = default${reset}"
        echo -e "${bg_default_col2}${txt_default_col2}Column 2 background = def>
        echo -e "${txt_default_col2}Column 2 font color = default${reset}"
else
    col_bg_1="${background[$column1_background]}"
    col_txt_1="${text[$column1_font_color]}"
    col_bg_2="${background[$column2_background]}"
    col_txt_2="${text[$column2_font_color]}"

    echo -e "${col_bg_1}${col_txt_1}Column 1 background = ${column1_background}>
    echo -e "${col_txt_1}Column 1 font color = ${column1_font_color}${reset}"
    echo -e "${col_bg_2}${col_txt_2}Column 2 background = ${column2_background}>
    echo -e "${col_txt_2}Column 2 font color = ${column2_font_color}${reset}"
fi