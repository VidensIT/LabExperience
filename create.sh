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
sudo mv *_filedownload /var/www/html/

sudo chmod 704 /var/www/html/*

sudo rm /var/www/html/index.nginx-debian.html

echo "Restarting service..."

sudo systemctl restart nginx

echo "Script finished!"