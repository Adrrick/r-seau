#!/bin/bash
# 30/09/2020
# Tristan
# node1 auto config

setenforce 0
systemctl start firewalld
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --reload
mkdir /srv/site1
touch /srv/site1/index.html
echo "<!DOCTYPE html>
<p> Site1 </p>" > /srv/site1/index.html
mkdir /srv/site2
touch /srv/site2/index.html
echo "<!DOCTYPE html>
<p> Site2 </p>" > /srv/site2/index.html
touch script.sh
echo "#!/bin/bash
# 27/09/2020
# Tristan
# script backup site

d_path=\"\$1\"
oldest=\"\"
nb_backups=\$(ls /home/backups/ | wc -l)
now=\$(date \"+%Y%m%d_%H%M\")
backup_uid=1003

if [[ \${EUID} -ne \"\$backup_uid\" ]]; then
        echo \"Erreur : seul backup peut lancer ce script.\"
        exit 1
fi

if [[ \"\$d_path\" = \"\" ]]; then
        for file in /srv/*
        do
                tar -zcvf \${file}_\${now}.tar.gz \${file}
                mv \${file}_\${now}.tar.gz /home/backups/
        done
        nb_backups=\$((\$nb_backups + 2))
fi

if [[ \"\$d_path\" = \"/srv/site1\" ]]; then
        tar -zcvf site1_\${now}.tar.gz /srv/site1
        mv site1_\${now}.tar.gz /home/backups/
        nb_backups=\$((\$nb_backups + 1))
fi

if [[ \"\$d_path\" = \"/srv/site2\" ]]; then
        tar -zcvf site2_\${now}.tar.gz /srv/site2
        mv site2_\${now}.tar.gz /home/backups/
        nb_backups=\$((\$nb_backups + 1))
fi

while [[ \"\$nb_backups\" -gt '7' ]]; do

        oldest=\$(ls -tr /home/backups/ | head -1)
        rm /home/backups/\$oldest
        nb_backups=\$((\$nb_backups - 1))
        echo \$oldest
        echo \"Archive la plus ancienne supprimée\"
done

exit 0" > script.sh
mkdir /home/backups
chmod 750 /home/backups
chmod 754 script.sh
chmod 770 /srv
chmod 570 /srv/site1
chmod 570 /srv/site2
chmod 770 /srv/site1/index.html
chmod 770 /srv/site2/index.html
echo "192.168.1.12    node2.tp2.b2" >> /etc/hosts
useradd admin
echo "admin" | passwd --stdin admin
echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers
useradd usernginx
echo "usernginx" | passwd --stdin usernginx
useradd backup
echo "backup" | passwd --stdin backup
chown usernginx:backup /srv/site1
chown usernginx:backup /srv/site2
chown usernginx:backup /srv/site1/index.html
chown usernginx:backup /srv/site2/index.html
chown backup:backup /home/backups
chown backup:backup script.sh
chown usernginx:backup /srv
mv script.sh /home/backup
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
                listen 443 ssl;
                server_name node1.tp2.b2;
                ssl_certificate /etc/pki/tls/certs/server.crt;
                ssl_certificate_key /etc/pki/tls/private/server.key;

                location / {
                        return 301 /site1;
                }

                location /site1 {
                        alias /srv/site1;
                }

                location /site2 {
                        alias /srv/site2;
                }
         }
}" > /etc/nginx/nginx.conf
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt -subj "/CN=node1.tp2.b2"
mv server.key /etc/pki/tls/private
mv server.crt /etc/pki/tls/certs
systemctl start nginx