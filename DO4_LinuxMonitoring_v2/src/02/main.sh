#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Ошибка. Укажите 3 параметра "
    exit 1
elif [[ ! $1 =~ ^[A-Za-z]{1,7}$ ]]; then
    echo "Ошибка. Укажите не более 7 букв английского алфавита."
    exit 1
elif [[ ! $2 =~ ^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$ ]]; then
    echo "Ошибка. Укажите имя(до 7 символов) и расширение(до 3 символов) в формате хххх.ххх"
    exit 1
elif [[ ! $3 =~ (^[1-9][0-9]?|100)Mb$ ]]; then
    echo "Ошибка. Размер не больше 100Мб"
    exit 1
fi

start_sec=$(date +%s)
start_time=$(date +"%d.%m.%y %H:%M:%S")
folder_chars="$1"
filename="${2%.*}"
extension="${2#*.}"
file_size="${3%Mb}"
data=$(date +'%d%m%y')
log="info.log"
count=0\

get_unique_chars() {
    echo "$1" | grep -o . | awk '!seen[$0]++' | tr -d '\n'
}

generate_string() {
    local chars="$1"
    local len="$2"
    local n=${#chars}
    
    local result=""
    for ((i = 0; i < n; i++)); do
        result+="${chars:$i:1}"
    done
    
    for ((i = n; i < len; i++)); do
        index=$((RANDOM % n))
        char="${chars:$index:1}"
        result+="$char"
    done
    
    echo "$result"
}

memcheck() {
    free_space=$(df -k / | awk 'NR==2 {print $4}')
    if [ $free_space -lt 1048576 ]; then
    echo "Память менее 1 Гб"
    end_time=$(date +"%d.%m.%y %H:%M:%S")
    end_sec=$(date +%s)
    res=$(($end_sec - $start_sec))

    echo "==========================================" >> "$log"
    echo "Время начала: $start_time" >> "$log"
    echo "Время окончания: $end_time" >> "$log"
    echo "Общее время работы: $res сек" >> "$log"
    exit 1
    fi
}

while [ $count -lt 100 ]; do
    memcheck
    unique_folder_chars=$(get_unique_chars "$folder_chars")
    folder_len=$(( RANDOM % 3 + 5 ))
    folder_name="$(generate_string "$unique_folder_chars" "$folder_len")_$data"
    
    candidates=$(find / -type d -writable 2>/dev/null | grep -v -E '/bin|/sbin|/proc|/dev|/sys' | shuf -n 1)
    full_path="$candidates/$folder_name"
    
    mkdir -p "$full_path" 2>/dev/null
    if [ $? -ne 0 ]; then
        continue
    fi
    
    folder_time=$(date +"%d.%m.%y %H:%M:%S")
    echo "Каталог: $full_path" >> "$log"
    echo "Создан: $folder_time" >> "$log"
    echo "------------------------------------------" >> "$log"
    
    file_count=$(( RANDOM % 10 + 1 ))
    for ((i = 0; i < file_count; i++)); do
        memcheck
        
        unique_filename=$(get_unique_chars "$filename")
        unique_ext_chars=$(get_unique_chars "$extension")
        file_len=$(( RANDOM % 3 + 5 ))
        ext_len=$(( RANDOM % 3 + 1 ))
        
        file_name="$(generate_string "$unique_filename" "$file_len").$(generate_string "$unique_ext_chars" "$ext_len")"
        file_path="$full_path/$file_name"
        
        if ! fallocate -l "${file_size}M" "$file_path" 2>/dev/null; then
            continue
        fi
        
        file_time=$(date +"%d.%m.%y %H:%M:%S")
        echo "Файл: $file_path" >> "$log"
        echo "Создан: $file_time" >> "$log"
        echo "Размер: ${file_size}Mb" >> "$log"
        echo "------------------------------------------" >> "$log"
    done
    
    ((count++))
done

end_time=$(date +"%d.%m.%y %H:%M:%S")
end_sec=$(date +%s)
res=$(($end_sec - $start_sec))

echo "==========================================" >> "$log"
echo "Время начала: $start_time" >> "$log"
echo "Время окончания: $end_time" >> "$log"
echo "Общее время работы: $res сек" >> "$log"

echo "Время начала: $start_time"
echo "Время окончания: $end_time"
echo "Общее время работы: $res сек"