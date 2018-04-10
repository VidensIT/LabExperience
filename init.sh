#!/usr/bin/env bash

# update package source
sudo apt-get -y update

# install NGINX
sudo apt-get -y install nginx git

git clone https://github.com/tjongerius/LabExperience.git

cd LabExperience

bash ./create.sh