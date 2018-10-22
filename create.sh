#!/usr/bin/env bash

echo "Create large files..."

echo "Create 1MB file..."
head -c 1073741 < /dev/urandom > 1m_filedownload
echo "Create 10MB file..."
head -c 10737410 < /dev/urandom > 10m_filedownload
echo "Create 100MB file..."
head -c 107374100 < /dev/urandom > 100m_filedownload
echo "Create 1GB file..."
head -c 1073741000 < /dev/urandom > 1000m_filedownload

echo "Finished creating large files!"

echo "Creating page..."

python ./generate_page.py

echo "Moving data to web folder..."

sudo mv index.html /var/www/html/
sudo cp *_filedownload /var/www/html/
sudo cp -R assets /var/www/html/
sudo cp -R images /var/www/html/

sudo chmod 704 /var/www/html/*

sudo rm /var/www/html/index.nginx-debian.html

sudo chmod -R 777 /var/www/html/

echo "Restarting service..."

sudo systemctl restart nginx

echo "Setting up VLC service..."
sudo iptables -A INPUT -p tcp --dport 8082 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 8082 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 1234 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 1234 -j ACCEPT

echo "Setting up FTP service..."

sudo cp ./vsftpd.conf /etc/
sudo iptables -A INPUT -p tcp --dport 10090:10100 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 20:21 -j ACCEPT

echo "Creating files..."

sudo mkdir -p /srv/files/ftp
sudo usermod -d /srv/files/ftp ftp
sudo cp *_filedownload /srv/files/ftp/

echo "Restarting service..."

sudo systemctl restart vsftpd.service

echo "Script finished!"

python ./give_ip.py
