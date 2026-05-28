#!/bin/bash

cidr=$(ip -o -f inet addr show | grep 'inet' | head -n 1 | awk '{print $4}' | cut -d '/' -f2)
    mask=""
    for i in 1 2 3 4; do
        if [ $cidr -ge 8 ]; then
            mask+="255."
            cidr=$((cidr-8))
        else
            mask+=$((256-(2**(8-$cidr)))).
            cidr=0
        fi
    done
    echo "${mask%.}"