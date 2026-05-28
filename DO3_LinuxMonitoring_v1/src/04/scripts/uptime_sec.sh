#!/bin/bash

echo "$(awk '{print int($1)}' /proc/uptime)"