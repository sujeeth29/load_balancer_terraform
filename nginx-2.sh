#!/bin/bash
sudo -i
apt update -y
apt install nginx -y
echo "This is the server-2" >> /var/www/html/index.html
systemctl restart nginx
apt install mysql-server -y
