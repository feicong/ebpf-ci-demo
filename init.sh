#!/bin/bash

rm -rf *.deb
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.16.2-amd64.deb

sudo apt-get update -y && sudo apt install gnome-terminal qemu docker-ce-cli pass -y
sudo dpkg -i docker-desktop-4.16.2-amd64.deb
sudo docker images

