#!/bin/bash
apt -y update
apt -y install apache2
cat <<EOF > /var/www/html/index.html
<html>

<h2>Build by Terraform</h2><br>
Owner Vladyslav <br>

<html>
EOF
sudo service apache2 start
sudo systemctl enable apache2
