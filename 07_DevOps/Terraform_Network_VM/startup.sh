#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

# Create a custom index page
echo "<h1>Deployed via Terraform Split Logic</h1><p>Region: europe-west10</p>" > /var/www/html/index.html
