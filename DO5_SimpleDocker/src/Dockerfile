FROM nginx:stable
RUN apt-get update && apt-get install -y gcc libfcgi-dev spawn-fcgi && rm -rf /var/lib/apt/lists/*
COPY quest3.c /server/quest3.c
RUN gcc /server/quest3.c -o /server/quest3.fcgi -lfcgi
COPY ./nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 8080
CMD ["sh", "-c", "nginx -g 'daemon off;' & spawn-fcgi -p 8080 -n /server/quest3.fcgi"]