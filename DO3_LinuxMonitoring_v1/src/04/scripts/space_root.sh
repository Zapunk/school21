#!/bin/bash

echo "$(df -BM --output=size,used,avail / | awk 'NR==2 {printf "%.2f MB\n", $1}')"