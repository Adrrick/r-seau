#!/bin/bash 

setenforce 0
systemctl start firewalld
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload
echo "192.168.1.11 gitea" >> /etc/hosts
echo "192.168.1.13 nginx" >> /etc/hosts
echo "192.168.1.14 nfs" >> /etc/hosts

yum install -y mariadb-server

echo "bind-address = 192.168.1.12" >> /etc/my.cnf

systemctl enable mariadb.service
systemctl start mariadb.service

mysql -u root -e "SET old_passwords=0;
CREATE USER 'gitea'@'192.168.1.11' IDENTIFIED BY 'gitea';
CREATE DATABASE giteadb CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
GRANT ALL PRIVILEGES ON giteadb.* TO 'gitea'@'192.168.1.11';
FLUSH PRIVILEGES;"
