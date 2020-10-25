#!/bin/bash 

setenforce 0
systemctl start firewalld
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
echo "192.168.1.11 gitea" >> /etc/hosts
echo "192.168.1.12 mariadb" >> /etc/hosts
echo "192.168.1.14 nfs" >> /etc/hosts
yum install -y epel-release
yum install -y nginx
useradd usernginx
echo "usernginx" | passwd --stdin usernginx
echo "user usernginx;
worker_processes 1;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}
    http {
        server {
            listen 80;
            server_name git.example.com;

            location / {
                proxy_pass http://192.168.1.11:3000;
        }
    }
}" > /etc/nginx/nginx.conf

systemctl start nginx