#======== shell script file ============
start_time=`date +%s`
#======== shell script start ===========


echo "---- CentOS7.x install mysql + php + nginx + redis + phpmyadmin----"
sleep 3
cd ~
mkdir download
cd download
yum -y install wget unzip gcc gcc-c++ make cmake autoconf automake openssl openssl-devel openssl-perl openssl-static zlib zlib-devel pcre pcre-devel ncurses ncurses-devel bison bison-devel curl curl-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel libxml2 libxml2-devel gd gd-devel freetype freetype-devel libjpeg libjpeg-devel libpng libpng-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers libXpm libXpm-devel t1lib t1lib-devel libxslt libxslt-devel net-snmp net-snmp-devel

wget http://nginx.org/download/nginx-1.21.0.tar.gz
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.35.tar.gz
wget https://www.php.net/distributions/php-7.2.19.tar.gz
wget http://download.redis.io/releases/redis-5.0.5.tar.gz
#wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
#wget https://pecl.php.net/get/event-2.5.0.tgz
#wget https://github.com/phpredis/phpredis/archive/4.3.0.tar.gz
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.5/phpMyAdmin-4.8.5-all-languages.zip

cd /root/download/
groupadd www
useradd -g www www
groupadd mysql
useradd -g mysql mysql

chmod 755 /home/www /home/mysql
chown www:www /home/www
chown mysql:mysql /home/mysql

clear
echo "---- install mysql ----"
sleep 2

tar zxvf mysql-5.7.35.tar.gz
cd mysql-5.7.35
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/home/mysql -DSYSCONFDIR=/usr/local/mysql -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DMYSQL_USER=mysql -DWITH_DEBUG=0 -DMYSQL_TCP_PORT=3306 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 -DWITH_SSL=yes
make
make install

cp /usr/local/mysql/support-files/my-default.cnf /usr/local/mysql/my.cnf
rm -f /etc/my.cnf
ln -s /usr/local/mysql/my.cnf /etc/my.cnf
ln -s /usr/local/mysql/bin/mysql* /usr/bin
/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysql


echo "---- install nginx ----"
sleep 2
cd /root/download/
tar zxvf nginx-1.21.0.tar.gz 
cd nginx-1.21.0
./configure --user=www --group=www --prefix=/usr/local/nginx --pid-path=/tmp/nginx.pid --with-http_stub_status_module --with-http_ssl_module
make
make install

cd /root/download
mkdir /usr/local/nginx/conf/vhosts/
#\cp ./nginx.conf /usr/local/nginx/conf/
ln -s /usr/local/nginx/conf/nginx.conf /etc/nginx.conf
ln -s /usr/local/nginx /usr/bin

clear
echo "---- install php ----"
sleep 2
cd /root/download/
tar -xzvf curl-7.64.1.tar.gz
cd curl-7.64.1
./configure --prefix=/usr/local/curl
make && make install

#cd /root/download/
#tar -xzvf libevent-2.1.8-stable.tar.gz
#cd libevent-2.1.8-stable
#./configure --prefix=/usr/local/libevent-2.1.8
#make && make install

cd /root/download/
tar -zxvf php-7.2.19.tar.gz
cd php-7.2.19
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysqli=/usr/local/mysql/bin/mysql_config --with-libxml-dir --with-iconv-dir --with-freetype-dir --with-png-dir --with-jpeg-dir --with-zlib --with-mhash --with-gd --enable-bcmath --with-curl=/usr/local/curl --with-bz2 --enable-zip --with-openssl --with-openssl-dir --without-pear --enable-mbstring --enable-soap --enable-xml --enable-pdo --enable-ftp --enable-bcmath --enable-sockets --with-xmlrpc --with-xsl --enable-sysvsem --enable-sysvshm --enable-maintainer-zts --enable-calendar --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-wddx --enable-shmop --enable-exif --enable-pcntl
make
make install

cp php.ini-development /usr/local/php/etc/php.ini
sed -i "s/;date.timezone =/date.timezone = PRC/" /usr/local/php/etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
ln -s /usr/local/php/etc/php.ini /etc/php.ini
ln -s /usr/local/php/etc/php-fpm.conf /etc/php-fpm.conf
ln -s /usr/local/php/bin/php* /usr/local/bin/
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

cd ./ext/pdo_mysql
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql
make && make install
echo extension=pdo_mysql.so >> /usr/local/php/etc/php.ini

#cd /root/download
#tar -zxvf event-2.5.0.tgz
#cd event-2.5.0
#/usr/local/php/bin/phpize
#./configure --with-php-config=/usr/local/php/bin/php-config --with-event-libevent-dir=/usr/local/libevent-2.1.8
#make && make install
#echo extension=event.so >> /usr/local/php/etc/php.ini


clear
echo "---- install redis ----"
sleep 2
cd /root/download

tar -zxvf redis-5.0.5.tar.gz
redis-5.0.5
make
cd src
make install
mkdir -p /usr/local/redis/bin /usr/local/redis/etc /usr/local/redis/logs  /usr/local/redis/rdb
cp mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis/bin/
cd ../
cp redis.conf /usr/local/redis/etc/
sed -i "s/daemonize no/daemonize yes/" /usr/local/redis/etc/redis.conf
ln -s /usr/local/redis/bin/redis_cli /usr/bin

#clear
#echo "---- install phpredis ----"
#sleep 2
#cd /root/download
#tar -zxvf 4.3.0.tar.gz
#cd phpredis-4.3.0
#/usr/local/php/bin/phpize
#./configure --with-php-config=/usr/local/php/bin/php-config
#make && make install
#echo extension=redis.so >> /usr/local/php/etc/php.ini


clear
echo "---- install phpmyadmin ----"
sleep 2
cd /root/download


unzip phpMyAdmin-4.8.5-all-languages.zip
mv phpMyAdmin-4.8.5-all-languages /home/www/phpmyadmin
chown -R www:www /home/www/phpmyadmin
cd

echo "
pkill nginx
pkill redis
pkill php

/usr/local/php/sbin/php-fpm -d start
/usr/local/mysql/support-files/mysql.server stop
/usr/local/mysql/support-files/mysql.server start
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf

netstat -antp | grep php
netstat -antp | grep redis
netstat -antp | grep mysql
netstat -antp | grep nginx
" > /root/lnmp.sh
chmod +x /root/lnmp.sh

sh /root/lnmp.sh

echo "---------------------------------------------"
echo "---- source dir: /root/download/   ----------"
echo "---- php dir: /usr/local/php/      ----------"
echo "---- nginx dir: /usr/local/nginx/    ----------"
echo "---- mysql dir: /usr/local/mysql/    ----------"
echo "---- redis dir: /usr/local/redis/    ----------"
echo "---- start lnmp: ~/lnmp.sh         ----------"
echo "---------------------------------------------"

#======== shell script over ===========
over_time=`date +%s`

use_time=$[$over_time-$start_time]

if [ $use_time -le 60 ]
then

use_second=$use_time
use_minutes=0

else

use_second=$[$use_time%60]
use_minutes=$[$use_time/60]

fi

echo When you use shell script:$use_minutes minutes $use_second second
