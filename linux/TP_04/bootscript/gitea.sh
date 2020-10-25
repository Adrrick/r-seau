#!/bin/bash 

setenforce 0
systemctl start firewalld
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
echo "192.168.1.12 mariadb" >> /etc/hosts
echo "192.168.1.13 nginx" >> /etc/hosts
echo "192.168.1.14 nfs" >> /etc/hosts

yum install -y git
yum install -y wget
yum install -y mysql
useradd git

wget -O gitea https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64
chmod +x gitea

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

cp gitea /usr/local/bin/gitea

touch /etc/systemd/system/gitea.service

echo "[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/gitea.service

systemctl enable gitea.service
systemctl start gitea.service