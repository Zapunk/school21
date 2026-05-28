#!/bin/bash

if [ $# -ne 6 ]; then
    echo "Ошибка! Введите 6 параметров"
    exit 1
elif [[ ! -d $1 ]]; then
    echo "Директория не существует"
    exit 1
elif [[ ! $2 =~ ^[1-9][0-9]*$ ]]; then
    echo "Ошибка. Укажите число папок"
    exit 1
elif [[ ! $3 =~ ^[A-Za-z]{1,7}$ ]]; then
    echo "Ошибка. Укажите не более 7 букв английского алфавита"
    exit 1
elif [[ ! $4 =~ ^[1-9][0-9]*$ ]]; then
    echo "Ошибка. Укажите число файлов"
    exit 1
elif [[ ! $5 =~ ^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$ ]]; then
    echo "Ошибка. Введите название в формате ххххх.ххх"
    exit 1
elif [[ ! $6 =~ (^[1-9][0-9]?|100)$ ]]; then
    echo "Ошибка. Укажите размер файла не больше 100 kb"
    exit 1
fi

set -e

dir="$1"
folders=$2
folder_chars="$3"
files=$4
file_template="$5"
size=$6
date_str=$(date +'%d%m%y')
base_chars="${file_template%.*}"
ext_chars="${file_template#*.}"
log="${dir}/info.log"
> "$log"

memcheck() {
    free_space=$(df -k / | awk 'NR==2 {print $4}')
    if [ $free_space -lt 1048576 ]; then
        exit 1
    fi
}

generate_ordered_name() {
    local chars=$1
    local min_len=4
    local name=""
    
    for ((i = 0; i < ${#chars}; i++)); do
        if [ $((RANDOM % 100)) -lt 60 ]; then
            name+="${chars:$i:1}"
        fi
    done
    
    if [ -z "$name" ]; then
        name="${chars:0:1}"
    fi
    
    while [ ${#name} -lt $min_len ]; do
        char="${chars:$((RANDOM % ${#chars})):1}"
        
        pos=0
        for ((j = 0; j < ${#name}; j++)); do
            c="${name:$j:1}"
            if [[ "${chars%%$c*}" != "${chars%%$char*}" ]] && [[ "${chars%%$char*}" < "${chars%%$c*}" ]]; then
                pos=$j
                break
            fi
            pos=$((j + 1))
        done
        
        name="${name:0:$pos}$char${name:$pos}"
    done
    
    echo "$name"
}

used_folder_names=()

for ((i = 0; i < folders; i++)); do
    memcheck
    
    while true; do
        folder_base=$(generate_ordered_name "$folder_chars")
        folder_name="${folder_base}_${date_str}"
        full_folder_path="${dir}/${folder_name}"
        
        if [[ ! " ${used_folder_names[@]} " =~ " ${full_folder_path} " ]] && [ ! -d "$full_folder_path" ]; then
            used_folder_names+=("$full_folder_path")
            break
        fi
    done
    
    mkdir -p "$full_folder_path"

    echo "Dir_path: $full_folder_path" >> "$log"
    echo "Dir_date: $(date '+%d.%m.%Y')" >> "$log"
    
    used_file_names=()
    
    for ((j = 0; j < files; j++)); do
        memcheck

        while true; do
            file_base=$(generate_ordered_name "$base_chars")
            file_name="${file_base}_${date_str}.${ext_chars}"
            full_file_path="${full_folder_path}/${file_name}"
            
if [[ ! " ${used_file_names[@]} " =~ " ${file_name} " ]] && [ ! -f "$full_file_path" ]; then
                used_file_names+=("$file_name")
                break
            fi
        done
        
        dd if=/dev/zero of="$full_file_path" bs=1024 count=$size status=none

        echo "File_path: $full_file_path" >> "$log"
        echo "File_date: $(date '+%d.%m.%Y')" >> "$log"
        echo "File_size: ${size}KB" >> "$log"
        echo "------------------------------------------------" >> "$log"
    done
done