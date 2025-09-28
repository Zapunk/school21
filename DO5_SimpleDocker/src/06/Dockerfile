FROM nginx:stable
RUN apt-get update && apt-get install -y gcc libfcgi-dev spawn-fcgi && rm -rf /var/lib/apt/lists/*
WORKDIR /server
COPY quest6.c /server/quest6.c
RUN gcc quest6.c -o quest6.fcgi -lfcgi
COPY ./nginx/nginx.conf /etc/nginx/conf.d
#EXPOSE 81
CMD ["sh", "-c", "spawn-fcgi -p 8080 -n /server/quest6.fcgi & nginx -g 'daemon off;'"]