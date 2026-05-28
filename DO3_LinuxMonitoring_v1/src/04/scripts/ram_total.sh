#!/bin/bash

echo "$(free -b | awk '/Mem:/ {printf "%.3f GB\n", $2 / (1024^3)}')"