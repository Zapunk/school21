FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y gcc libfcgi-dev spawn-fcgi nginx curl ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY quest5.c /app/quest5.c
COPY start.sh /app/start.sh
RUN gcc /app/quest5.c -o /app/quest5 -lfcgi && chmod +x /app/start.sh
RUN useradd -m -d /home/spectrav -s /bin/bash spectrav \
 && mkdir -p /var/cache/nginx /var/run \
 && chown -R spectrav:spectrav /app /var/cache/nginx /var/run /home/spectrav
RUN touch /var/run/nginx.pid; \
    chown -R spectrav:spectrav /var/run/nginx.pid; \
    chown -R spectrav:spectrav /etc/nginx/nginx.conf; \
    chown -R spectrav:spectrav /var/cache/nginx; \
    chown -R spectrav:spectrav /home; \
    chmod u-s /usr/bin/gpasswd; \
    chmod u-s /usr/bin/newgrp; \
    chmod u-s /bin/su; \
    chmod u-s /bin/mount; \
    chmod u-s /bin/umount; \
    chmod u-s /usr/bin/chsh; \
    chmod u-s /usr/bin/chfn; \
    chmod u-s /usr/bin/chsh; \
    chmod g-s /usr/bin/expiry; \
    chmod g-s /usr/bin/wall; \
    chmod g-s /sbin/unix_chkpwd; \
    chmod g-s /usr/bin/chage; \
    chmod u-s /usr/bin/passwd
USER spectrav
EXPOSE 8080
HEALTHCHECK none
CMD ["sh", "/app/start.sh"]