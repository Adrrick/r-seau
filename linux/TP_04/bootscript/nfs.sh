#!/bin/bash 

setenforce 0
systemctl start firewalld
echo "192.168.1.11 gitea" >> /etc/hosts
echo "192.168.1.12 mariadb" >> /etc/hosts
echo "192.168.1.13 nginx" >> /etc/hosts