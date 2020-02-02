#!/usr/bin/env bash

vars='\$REMOTE_DEBUG_HOST \$FILE_SIZE_MAX'

export REMOTE_DEBUG_HOST=${REMOTE_DEBUG_HOST} \
       FILE_SIZE_MAX=${FILE_SIZE_MAX}

envsubst "$vars" < "/etc/nginx/conf.d/default.conf.tpl" > "/etc/nginx/conf.d/default.conf"

nginx -g 'daemon off;'
