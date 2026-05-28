#!/bin/bash

echo "$(df -BM / | awk 'NR==2 {printf "%.2f MB\n", $3}')"