FROM php:7.2-fpm

RUN apt-get update &&\
    apt-get install -y \
    libpq-dev \
    libpcre3-dev \
    zlib1g-dev \
    cron \
    nano \
    gettext \
    libgmp-dev

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    bcmath \
    mbstring \
    zip \
    opcache \
    gmp

# Php
COPY devops/php_fpm/php.ini-development.tpl /usr/local/etc/php/
COPY devops/php_fpm/php.ini-production.tpl /usr/local/etc/php/
COPY devops/php_fpm/php-fpm.conf.tpl /usr/local/etc/php-fpm.conf.tpl

# Xdebug
RUN pecl install xdebug-2.7.2 &&\
    docker-php-ext-enable xdebug
COPY devops/php_fpm/99-xdebug.ini.tpl /usr/local/etc/php/conf.d/

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin \
    && php -r "unlink('composer-setup.php');"

# Cron
RUN mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron
ADD devops/php_fpm/crontab /etc/cron.d/php-schedule-run
RUN chmod 0644 /etc/cron.d/php-schedule-run &&\
    touch /var/log/cron.log
COPY devops/php_fpm/start-cron.sh /usr/sbin
RUN chmod +x /usr/sbin/start-cron.sh

# Boot.sh
COPY devops/php_fpm/boot.sh /usr/local/bin/php_boot.sh
RUN chmod +x /usr/local/bin/php_boot.sh

# Wait for it (wait mysql container)
COPY devops/php_fpm/wait-for-it.sh /usr/local/bin/wait-for-it.sh

CMD /usr/local/bin/wait-for-it.sh $DB_HOST:$DB_PORT -- /usr/local/bin/php_boot.sh
