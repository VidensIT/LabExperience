#!/usr/bin/env bash

head -c 1073741 < /dev/urandom > 1m_filedownload
head -c 10737410 < /dev/urandom > 10m_filedownload
head -c 107374100 < /dev/urandom > 100m_filedownload
head -c 1073741000 < /dev/urandom > 1000m_filedownload

python ./generate_page.py

sudo mv index.html /var/www/html/
sudo mv *_filedownload /var/www/html/

sudo chmod 704 /var/www/html/*

sudo rm /var/www/html/index.nginx-debian.html

sudo systemctl restart nginx

