#!/bin/base
apt update
apt install apache2
echo "<br><font color="blue">Hello world!!" >> /var/www/html/index.html
sudo service apache2 start
sudo systemctl enable apache2
