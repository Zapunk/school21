#!/bin/bash

sudo chmod +x *.sh
sudo chmod +x scripts/*.sh

output="HOSTNAME = $(scripts/hostname.sh)\n\
TIMEZONE = $(scripts/timezone.sh)\n\
USER = $(scripts/user.sh)\n\
OS = $(scripts/os.sh)\n\
DATE = $(scripts/date.sh)\n\
UPTIME = $(scripts/uptime.sh)\n\
UPTIME_SEC = $(scripts/uptime_sec.sh)\n\
IP = $(scripts/ip.sh)\n\
MASK = $(scripts/mask.sh)\n\
GATEWATY = $(scripts/gateway.sh)\n\
RAM_TOTAL = $(scripts/ram_total.sh)\n\
RAM_USED = $(scripts/ram_used.sh)\n\
RAM_FREE = $(scripts/ram_free.sh)\n\
SPACE_ROOT = $(scripts/space_root.sh)\n\
SPACE_ROOT_USED = $(scripts/space_root_used.sh)\n\
SPACE_ROOT_FREE = $(scripts/space_root_free.sh)"

echo -e "$output"

read -p "Записать данные? (Y/N):" answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    filename=$(date +"%d_%m_%y_%H_%M_%S").status
    echo "$output" > "$filename"
fi