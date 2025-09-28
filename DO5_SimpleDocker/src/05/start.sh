#!/bin/bash
#gcc quest5.c -lfcgi -o quest5
#service nginx start
spawn-fcgi -p 8080 /app/quest5 &
nginx -g 'daemon off;'