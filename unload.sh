echo '---- unload nginx ----'
pkill nginx
rm -rf /usr/local/nginx

clear
echo '---- unload mysql ----'
pkill mysql
rm -rf /usr/local/mysql

clear
echo  '---- php ----'
pkill php
rm -rf /usr/local/php

clear
echo '---- redis ----'
pkill redis
rm -rf /usr/local/redis