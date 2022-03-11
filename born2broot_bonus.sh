DB_USER=root
DB_PASS=root
DB_WP_USER=wordpressuser
DB_WP_PASS=1234

## Configuration webserver
#
## Setup lighttpd
yum install -y lighttpd
# Disable IPV6 in config file /etc/lighttpd/lighttpd.conf
# server.use-ipv6 = "disable"
sed -i 's/^server.use-ipv6.*/server.use-ipv6 = "disable"/' /etc/lighttpd/lighttpd.conf
# allow firewall port 80
ufw allow 80

## Setup MariaDB
# install
yum -y install mariadb mariadb-server
# start service
systemctl start mariadb
# set start on reboot
systemctl enable mariadb
# secure installation
mysql_secure_installation
# Test it works
mysql -u root -p
# install php and php-fpm
yum -y install php php-mysqlnd php-pdo php-gd php-mbstring
# install addition module
yum -y install php-fpm lighttpd-fastcgi
# Grant permission for php-fpm
vi /etc/php-fpm.d/www.conf
#user = lighttpd
#group = lighttpd
#start php-fpm service
systemctl start php-fpm
systemctl enable php-fpm

vi /etc/php.ini
#cgi.fix_pathinfo=1

vi /etc/lighttpd/modules.conf
#include "conf.d/fastcgi.conf"

vi /etc/lighttpd/conf.d/fastcgi.conf
#fastcgi.server += ( ".php" =>
#        ((
#                "host" => "127.0.0.1",
#                "port" => "9000",
#                "broken-scriptfilename" => "enable"
#        ))
#)

systemctl restart lighttpd

vi /var/www/lighttpd/info.php
#<?php
#phpinfo();
#?>
curl http://127.0.0.1/info.php

#Setup Database
mysql -u root -p
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
FLUSH PRIVILEGES;