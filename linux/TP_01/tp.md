# TP1 : Déploiement classique

## 0. Prérequis

Ne t'étonne pas si le hostname change au milieu de certaines parties, je les ai pas faites dans l'ordre (j'ai fait ssh en premier pour pouvoir c/c)  

-VM 1 :  

* Partitionnement

J'ai ajouté un disque VDI VirtualDisk1 via virtualbox, puis ait fait les manips avec LVM.
```
[user@node1 ~]$ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0    8G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0    7G  0 part
  ├─centos-root 253:0    0  6.2G  0 lvm  /
  └─centos-swap 253:1    0  820M  0 lvm  [SWAP]
sdb               8:16   0    5G  0 disk
sr0              11:0    1 1024M  0 rom

[user@node1 ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.

[user@node1 ~]$ sudo pvs
  PV         VG     Fmt  Attr PSize  PFree
  /dev/sda2  centos lvm2 a--  <7.00g    0
  /dev/sdb          lvm2 ---   5.00g 5.00g

[user@node1 ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created

[user@node1 ~]$ sudo vgs
  VG     #PV #LV #SN Attr   VSize  VFree
  centos   1   2   0 wz--n- <7.00g     0
  data     1   0   0 wz--n- <5.00g <5.00g

[user@node1 ~]$ sudo lvcreate -L 2G data -n data1
[sudo] password for user:
  Logical volume "data1" created.
[user@node1 ~]$ sudo lvcreate -l 100%FREE data -n data2
  Logical volume "data2" created.

[user@node1 ~]$ sudo lvs
  LV    VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root  centos -wi-ao----  <6.20g
  swap  centos -wi-ao---- 820.00m
  data1 data   -wi-a-----   2.00g
  data2 data   -wi-a-----  <3.00g
  
  
[user@node1 ~]$ sudo mkfs -t ext4 /dev/data/data1
[sudo] password for user:
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

[user@node1 ~]$ sudo mkfs -t ext4 /dev/data/data2
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
196608 inodes, 785408 blocks
39270 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=805306368
24 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

[user@node1 ~]$ sudo mkdir /srv/site1
[user@node1 ~]$ sudo mount /dev/data/data1 /srv/site1
[user@node1 ~]$ sudo mkdir /srv/data2
[user@node1 ~]$ sudo mount /dev/data/site2 /srv/site2


[user@node1 ~]$ [user@node1 ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Fri Feb 21 15:38:04 2020
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root /                       xfs     defaults        0 0
UUID=860bbaa2-9b0d-43ba-9aae-635fcb67ef50 /boot                   xfs     defaults        0 0
/dev/mapper/centos-swap swap                    swap    defaults        0 0
/dev/data/data1 /srv/site1 ext4 defaults 0 0
/dev/data/data2 /srv/site2 ext4 defaults 0 0


[user@node1 ~]$ sudo umount /srv/site2
[user@node1 ~]$ sudo umount /srv/site1
[user@node1 ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
swap                     : ignored
mount: /srv/site1 does not contain SELinux labels.
       You just mounted an file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/srv/site1               : successfully mounted
mount: /srv/site2 does not contain SELinux labels.
       You just mounted an file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/srv/site2               : successfully mounted
```

* Accès internet

J'ai utilisé enp0s8 avec cette config, puis j'ai vérifié avec un curl :  
```
[user@localhost ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
[sudo] password for user:
TYPE=Ethernet
BOOTPROTO=static
DEVICE=enp0s8
ONBOOT=yes

IPADDR=192.168.1.11
NETMASK=255.255.255.0


[user@node1 ~]$ curl ynov.com
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
  "http://www.w3.org/TR/html4/frameset.dtd">

<html>
<head>
<title>301 Moved Permanently</title>
</head>

<body>
        <h1>Moved Permanently</h1>
        <p>Object moved permanently -- see URI list</h1>
</body>

</html>
```

* Accès réseau local

J'ai utilisé enp0s3 avec cette config, puis j'ai testé un ping :  
```
[user@node1 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE="Ethernet"
BOOTPROTO="dhcp"
DEVICE="enp0s3"
ONBOOT="yes"

[user@node1 ~]$ ping node2.tp1.b2
PING node2.tp1.b2 (192.168.1.12) 56(84) bytes of data.
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=1 ttl=64 time=0.653 ms
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=2 ttl=64 time=0.524 ms
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=3 ttl=64 time=0.348 ms
64 bytes from node2.tp1.b2 (192.168.1.12): icmp_seq=4 ttl=64 time=0.284 ms
^C
--- node2.tp1.b2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3018ms
rtt min/avg/max/mdev = 0.284/0.452/0.653/0.146 ms
```

* Nom

Je l'ai fait avec ton memo centos :  
```
[user@localhost ~]$ echo 'node1.tp1.b2' | sudo tee /etc/hostname
[sudo] password for user:
node1.tp1.b2
[user@localhost ~]$ poweroff
==== AUTHENTICATING FOR org.freedesktop.login1.power-off ===
Authentication is required for powering off the system.
Authenticating as: user
Password:
==== AUTHENTICATION COMPLETE ===


PS C:\Users\adrik> ssh user@192.168.1.11
user@192.168.1.11's password:
Last login: Wed Sep 23 11:06:01 2020 from 192.168.1.1
[user@node1 ~]$
```

* Résolution de nom

J'ai modifié /etc/hosts en ajoutant le nom de la deuxième VM  
```
[user@node1 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.12    node2.tp1.b2
```

* Admin

J'ai créé un user admin et ai modifié ses propriétés  
```
[user@node1 ~]$ sudo useradd admin
[user@node1 ~]$ sudo cat /etc/passwd
[...]
admin:x:1001:1001:admin:/home/admin:/bin/bash

[user@node1 ~]$ sudo visudo
[...]
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
admin   ALL=(ALL)       ALL
```

* SSH
```
PS C:\Users\adrik> ssh user@192.168.1.11
user@192.168.1.11's password:
Last login: Thu Sep 24 09:31:20 2020 from 192.168.1.1
[user@node1 ~]$
```

* Pare-feu

Tout était déjà bloqué de base sauf ssh, donc je n'ai rien modifié.  

-VM 2 :  

* Partitionnement
```
[user@node2 ~]$ df -h
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 908M     0  908M   0% /dev
tmpfs                    919M     0  919M   0% /dev/shm
tmpfs                    919M  8.6M  911M   1% /run
tmpfs                    919M     0  919M   0% /sys/fs/cgroup
/dev/mapper/centos-root  6.2G  1.4G  4.9G  23% /
/dev/sda1               1014M  193M  822M  19% /boot
/dev/mapper/data-data2   2.9G  9.0M  2.8G   1% /srv/site2
/dev/mapper/data-data1   2.0G  6.0M  1.8G   1% /srv/site1
tmpfs                    184M     0  184M   0% /run/user/1000
```

* Accès internet

```
[user@node2 ~]$ curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

* Accès réseau local
```
[user@node2 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE="Ethernet"
BOOTPROTO="dhcp"
DEVICE="enp0s3"
ONBOOT="yes"

[user@node2 ~]$ ping node2.tp1.b2
PING node2.tp1.b2 (10.0.2.15) 56(84) bytes of data.
64 bytes from node2.tp1.b2 (10.0.2.15): icmp_seq=1 ttl=64 time=0.033 ms
64 bytes from node2.tp1.b2 (10.0.2.15): icmp_seq=2 ttl=64 time=0.039 ms
64 bytes from node2.tp1.b2 (10.0.2.15): icmp_seq=3 ttl=64 time=0.090 ms
64 bytes from node2.tp1.b2 (10.0.2.15): icmp_seq=4 ttl=64 time=0.040 ms
^C
--- node2.tp1.b2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3066ms
rtt min/avg/max/mdev = 0.033/0.050/0.090/0.024 ms
```

* Nom
```
PS C:\Users\adrik> ssh user@192.168.1.12
user@192.168.1.12's password:
Last login: Thu Sep 24 09:26:18 2020 from 192.168.1.1
[user@node2 ~]$
```

* Résolution de nom
```
[user@node2 ~]$ sudo vim /etc/hosts
[sudo] password for user:
[user@node2 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.11    node1.tp1.b2
```

* Admin
```
[user@node2 ~]$ cat /etc/passwd
[...]
admin:x:1001:1001:admin:/home/admin:/bin/bash

[user@node2 ~]$ sudo cat /etc/sudoers
[sudo] password for user:
[...]
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
admin   ALL=(ALL)       ALL
```

* SSH
```
PS C:\Users\adrik> ssh user@192.168.1.12
user@192.168.1.12's password:
Last login: Thu Sep 24 09:18:45 2020
[user@node2 ~]$
```

* Pare-feu

Tout était déjà bloqué de base sauf ssh, donc je n'ai rien modifié.  


## I. Setup serveur web

* Setup NGINX

J'ai installé epel pour pouvoir installer nginx  

```
[user@node1 ~]$ sudo yum install -y epel-release
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: miroir.univ-paris13.fr
 * extras: mirroir.wptheme.fr
 * updates: mirroir.wptheme.fr
[...]
Complete!

[user@node1 ~]$ sudo yum install nginx
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
epel/x86_64/metalink                                                                             |  14 kB  00:00:00
 * base: miroir.univ-paris13.fr
 * epel: mirror.neostrada.nl
 * extras: mirroir.wptheme.fr
 * updates: mirroir.wptheme.fr
[...]
Complete!
```

J'ai créé usernginx et un groupe du même nom pour les deux serveurs, puis j'ai fait les restrictions sur les serveurs et ait créé un index pour chaque serveur  

```
[user@node1]$ cat /etc/passwd
usernginx:x:1002:1002::/home/usernginx:/bin/bash

[user@node1 ~]$ sudo chmod 510 /srv/site1
[sudo] password for user:
[user@node1 ~]$ sudo chmod 510 /srv/site2
[user@node1 ~]$ cd /srv
[user@node1 srv]$ sudo chown usernginx:usernginx /srv/site1
[user@node1 srv]$ sudo chown usernginx:usernginx /srv/site2
[user@node1 srv]$ ls -al
total 8
drwxr-xr-x.  4 root      root        32 Sep 24 10:25 .
dr-xr-xr-x. 17 root      root       224 Feb 21  2020 ..
dr-x--x---.  3 usernginx usernginx 4096 Sep 23 12:03 site1
dr-x--x---.  3 usernginx usernginx 4096 Sep 23 12:03 site2
```

Ensuite j'ai modifié nginx.conf  
```
[user@node1]$ cat /etc/nginnnnn
user usernginx;
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
                server_name node1.tp1.b2;
                ssl_certificate /etc/pki/tls/certs/node1.tp1.b2.crt;
                ssl_certificate_key /etc/pki/tls/private/node1.tp1.b2.key;

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
}
```

Puis j'ai ouvert deux ports  
```
[user@node1 nginx]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] password for user:
success
[user@node1 nginx]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[user@node1 nginx]$ sudo firewall-cmd --reload
success
[user@node1 nginx]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: dhcpv6-client ssh
  ports: 80/tcp 443/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

On vérifie avec un curl  

```
[user@node1 ~]$ sudo systemctl start nginx

[user@node2 ~]$ curl -L node1.tp1.b2/site1
<!DOCTYPE html>

<p> Salut </p>
[user@node2 ~]$ curl -L node1.tp1.b2/site2
<!DOCTYPE html>

<p> Site2 </p>

[user@node2 ~]$ curl -L -k https://node1.tp1.b2/site2
<!DOCTYPE html>

<p> Site2 </p>
[user@node2 ~]$ curl -L -k https://node1.tp1.b2/site1
<!DOCTYPE html>

<p> Salut </p>
```

## II. Script de sauvegarde

Tout d'abord, voici le script, qui se situe dans ~ de backup :  

```
#!/bin/bash

oldest=""
nb_backups=$(ls /home/backups/ | wc -l)

now=$(date "+%Y%m%d_%H%M")

if [ "$1" = "" ]; then
        for file in /srv/*
        do
                tar -zcvf ${file}_${now}.tar.gz ${file}
                mv ${file}_${now}.tar.gz /home/backups/
        done
        nb_backups=$(($nb_backups + 2))
fi

if [ "$1" = "/srv/site1" ]; then
        tar -zcvf site1_${now}.tar.gz /srv/site1
        mv site1_${now}.tar.gz /home/backups/
        nb_backups=$(($nb_backups + 1))
fi

if [ "$1" = "/srv/site2" ]; then
        tar -zcvf site2_${now}.tar.gz /srv/site2
        mv site2_${now}.tar.gz /home/backups/
        nb_backups=$(($nb_backups + 1))
fi

while [ "$nb_backups" -gt '7' ]; do

        oldest=$(ls -tr /home/backups/ | head -1)
        rm /home/backups/$oldest
        nb_backups=$(($nb_backups - 1))
        echo $oldest
        echo "Archive la plus ancienne supprimée"
done

exit 0
```

Voici les droits du script :  

`-rwxr-xr--. 1 backup backup  795 Sep 27 14:32 tp1_backup.sh`

Et voici le résultat du script quand backup l'exécute :  

```
[backup@node1 ~]$ ./tp1_backup.sh
tar: Removing leading `/' from member names
/srv/site1/
/srv/site1/index.html
/srv/site1/lost+found/
tar: Removing leading `/' from member names
/srv/site2/
/srv/site2/lost+found/
/srv/site2/index.html
site2_20200927_1420.tar.gz
Archive la plus ancienne supprimée
site1_20200927_1422.tar.gz
Archive la plus ancienne supprimée
```

Ici on peut voir que mon dossier backups était déjà plein, donc le script à supprimé les deux archives les plus anciennes. En voici la preuve :  

* avant exécution :  

```
[backup@node1 ~]$ ls -al /home/backups/
total 28
drwxr-xr--. 2 backup backup 244 Sep 27 14:38 .
drwxr-xr-x. 7 root   root    77 Sep 26 21:27 ..
-rw-rw-r--. 1 backup backup 248 Sep 27 14:22 site1_20200927_1422.tar.gz
-rw-rw-r--. 1 backup backup 248 Sep 27 14:33 site1_20200927_1433.tar.gz
-rw-rw-r--. 1 backup backup 248 Sep 27 14:38 site1_20200927_1438.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:20 site2_20200927_1420.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:22 site2_20200927_1422.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:33 site2_20200927_1433.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:38 site2_20200927_1438.tar.gz
```

* après exécution :  

```
[backup@node1 ~]$ ls -al /home/backups/
total 28
drwxr-xr--. 2 backup backup 244 Sep 27 14:40 .
drwxr-xr-x. 7 root   root    77 Sep 26 21:27 ..
-rw-rw-r--. 1 backup backup 248 Sep 27 14:33 site1_20200927_1433.tar.gz
-rw-rw-r--. 1 backup backup 248 Sep 27 14:38 site1_20200927_1438.tar.gz
-rw-rw-r--. 1 backup backup 248 Sep 27 14:40 site1_20200927_1440.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:22 site2_20200927_1422.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:33 site2_20200927_1433.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:38 site2_20200927_1438.tar.gz
-rw-rw-r--. 1 backup backup 254 Sep 27 14:40 site2_20200927_1440.tar.gz
```

On voit bien que les sauvegarde site2 à 14:20 et site1 à 14:22 ont été supprimées.  

Pour la crontab :  

```
[backup@node1 ~]$ crontab -l
0 */1 * * * ./tp1_backup.sh
```

On lance tp1_backup.sh toutes les heures à 0 minute.

* Comment charger une sauvegarde précédente ?

Imaginons que je casse mon site1.  
Pour le réparer, je peux aller dans backups et chercher une sauvegarde de site1 (en étant backup).  
Je mv l'archive (dans mon répertoire courant par exemple), je l'extrait avec tar, je récupère le contenu de site1/ puis le remplace avec mon site1 dont je suis sûr qu'il ne marche plus.  
Si tout s'est bien passé, j'aurai perdu une portion de mon travail (minimum 1 heure si je ne sauvegarde jamais manuellement) mais site1 marchera à nouveau.  
Je peux vérifier en faisant un curl https://192.168.1.11 depuis node2.  


## III. Monitoring, alerting

J'ai suivi le script d'installation, ouvert le port 19999 et voici le résultat :  

![](https://i.imgur.com/AVjbtHg.png)


J'ai ensuite suivi la procédure de netdata pour recevoir les notifs Discord. Voici le contenu de ma conf Discord après avoir modifié `health_alarm_notify.conf` :  

```
#------------------------------------------------------------------------------
# discord (discordapp.com) global notification options

# multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discordapp.com/api/webhooks/760056519902756894/jVH4hbF_JK1kxR-Mj1NNQIl_0jz8iZMecPPrZFaVEFaSZjKJu39T8o2lqggQrEFFbpuG"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alarms"


#------------------------------------------------------------------------------
```

Puis j'ai créé une alerte `examplealerte.conf` dans `health.d` de netdata avec ce contenu :  

```
 alarm: ram_usage
 on: system.ram
lookup: average -1m percentage of used
 units: %
 every: 1m
 warn: $this > 10
 crit: $this > 20
 info: The percentage of RAM used by the system.
```

Et voilà mon bro qui me prévient :  

![](https://i.imgur.com/CIzc9jk.png)