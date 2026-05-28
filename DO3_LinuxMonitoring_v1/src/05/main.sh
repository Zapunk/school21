#!/bin/bash

start_time=$(date +%s)

if [ $# -ne 1 ] || [[ "$1" != */ ]]; then
    echo "Параметр введен не корректно"
    exit 1
fi

dir=$1

if [ ! -d "$dir" ]; then
    echo "Директория не существует"
    exit 1
fi

total_number=$(find "$dir" -type d | wc -l)
    echo "Total number of folders (including all nested ones) = $((total_number - 1))"

echo "TOP 5 folders of maximum size arranged in descending order (path and size):\n"
du -h "$dir" | sort -hr | head -n 6 | tail -n 5 | awk '{print NR "- " $2 ", " $1}'

total_files=$(find "$dir" -type f | wc -l)
    echo "Total number of files = $total_files"

echo "Number of:"

conf=$(find "$dir" -type f -name "*.conf" | wc -l)
    echo "Configuration files (with the .conf extension) = $conf"

text=$(find "$dir" -type f -exec file {} \; | grep -i "text" | wc -l)
    echo "Text files = $text"

exe=$(find "$dir" -type f -executable | wc -l)
    echo "Executable files = $exe"

log=$(find "$dir" -type f -name "*.log" | wc -l)
    echo "Log files (with the extension .log) = $log"

archive=$(find "$dir" -type f \( -name "*.zip" -o -name "*.tar" -o -name\
 "*.gz" -o -name "*.bz2" -o -name "*.rar" -o -name "*.7z" \) | wc -l)
    echo "Archive files = $archive"

links=$(find "$dir" -type l | wc -l)
    echo "Symbolic links = $links"

echo "TOP 10 files of maximum size arranged in descending order
(path, size and type):"
find "$dir" -type f -exec du -h {} + | sort -rh | head -n 10 | {
    counter=1
    while read -r size file; do
    type=$(file -b "$file" | sed 's/,.*//')
    echo "${counter} - $file, $size, $type"
    ((counter++))
done
}

echo "TOP 10 executable files of the maximum size arranged
in descending order (path, size and MD5 hash of file):"
find "$dir" -type f -executable -exec du -h {} + | sort -rh | head -n 10 | {
    counter=1
    while read -r size file; do
    hash=$(md5sum "$file" | awk '{print $1}')
    if [ -z "$hash" ]; then
        hash="Ошибка вычисления хеш"
    fi
    echo "${counter} - $file, $size, $hash"
    ((counter++))
done
}

end_time=$(date +%s)
execution=$(echo "$end_time - $start_time" | bc)
echo "Script execution time (in seconds) = $execution"