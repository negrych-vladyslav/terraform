#!/bin/base
apt update
apt install apache2
cat <<EOF > /var/www/html/index.html
<html>

<h2>Build by Terraform</h2><br>
Owner ${f_name} ${l_name} <br>

<html>
EOF
sudo service apache2 start
sudo systemctl enable apache2
