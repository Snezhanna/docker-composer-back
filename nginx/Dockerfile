FROM nginx:latest

COPY devops/nginx/config/default.conf.tpl /etc/nginx/conf.d/default.conf.tpl
COPY devops/nginx/boot.sh /usr/local/bin/nginx_boot

CMD ["sh", "/usr/local/bin/nginx_boot"]