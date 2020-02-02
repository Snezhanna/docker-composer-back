server {
    index index.php index.html;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/html/public;

    client_max_body_size ${FILE_SIZE_MAX};

    location / {
        index index.php;
        add_header Access-Control-Allow-Origin *;
        if (-f $request_filename) {
            break;
        }
        rewrite ^(.*)$ /index.php last;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php_fpm:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;

        fastcgi_param PHP_VALUE "xdebug.remote_autostart=1
        xdebug.remote_enable=1
        xdebug.remote_host=${REMOTE_DEBUG_HOST}
        upload_max_filesize=${FILE_SIZE_MAX}
        post_max_size=${FILE_SIZE_MAX}";
    }
}
