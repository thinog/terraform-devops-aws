#!/bin/bash
yum update -y
yum install -y httpd
echo "<b>Hello! Terraform here!</b>" > /var/www/html/index.html
service httpd start

sudo yum install -y epel-release

sudo amazon-linux-extras install epel

sudo yum install -y stress