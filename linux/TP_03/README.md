# TP3 : systemd

## I. Services systemd

### 0. Préparation

J'ai réutilisé la box du tp2. Je t'ai fourni le script dans scripts, il s'appelle `script.sh`.

### 1. Intro

* Nombre de services systemd dispos
```
[vagrant@tp3 ~]$ systemctl -t service | grep -c systemd
13
```

* Nombre de services systemd actifs
```
[vagrant@tp3 ~]$ systemctl -t service | grep systemd | grep -c running
3
```
* Nombre de services systemd qui ont échoué ou sont inactifs
```
[vagrant@tp3 ~]$ systemctl -t service | grep systemd | egrep -c "exited|failed"
10
```

* Liste des services systemd qui démarrent au boot
```
[vagrant@tp3 ~]$ systemctl list-unit-files | grep systemd | grep enabled
systemd-readahead-collect.service             enabled
systemd-readahead-drop.service                enabled
systemd-readahead-replay.service              enabled
```

### 2. Analyse d'un service

On analyse nginx.service :  

```
[vagrant@tp3 ~]$ systemctl status nginx.service
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-10-05 09:30:55 UTC; 1s ago
  Process: 3481 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 3478 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 3477 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)  
 Main PID: 3483 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3483 nginx: master process /usr/sbin/nginx
           └─3484 nginx: worker process
```
On peut voir que nginx.service a pour chemin `/usr/lib/systemd/system/nginx.service`, allons l'étudier :  
 
```
[vagrant@tp3 ~]$ systemctl cat nginx.service
# /usr/lib/systemd/system/nginx.service
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

* ExecStart : on exécute nginx
* ExecStartPre : commandes exécutées avant  d'exécuter nginx
* PIDFile : le fichier PID
* Type : type de démarrage du processus pour ce service
* ExecReload : reload la configuration
* Description : la description du service
* After : dépendance qui vérifie que les unités de service soient correctement terminées avant la fin du programme

Liste de tous les services contenant `WantedBy=multi-user.target` (je suis allé dans system au préalable) : 

```
[vagrant@tp3 system]$ grep -lr "WantedBy=multi-user.target" | grep service
rpcbind.service
rdisc.service
tcsd.service
sshd.service
rhel-configure.service
rsyslog.service
irqbalance.service
cpupower.service
crond.service
rpc-rquotad.service
wpa_supplicant.service
chrony-wait.service
chronyd.service
NetworkManager.service
ebtables.service
gssproxy.service
tuned.service
firewalld.service
nfs-server.service
rsyncd.service
nginx.service
vmtoolsd.service
postfix.service
auditd.service
```
### 3. Création d'un service

#### A. Serveur web
Avant toute chose j'ai ouvert le firewall  

`[vagrant@tp3 system]$ sudo firewalld`

Puis j'ai créé "web" dont le groupe "web" à tous les droits sudo sans mot de passe :  

```
## Same thing without a password
# %wheel        ALL=(ALL)       NOPASSWD: ALL
%web    ALL=(ALL)       NOPASSWD: ALL
```

J'ai créé le service serveurweb.service avec ce contenu :  
```
[Unit]
Description=TP3 serveur web

[Service]
Environment=PORT=8080
Type=simple
ExecStartPre=/usr/bin/sudo /usr/bin/firewall-cmd --add-port=${PORT}/tcp
ExecStart=/usr/bin/python2 -m SimpleHTTPServer ${PORT}
ExecStopPost=/usr/bin/sudo /usr/bin/firewall-cmd --remove-port=${PORT}/tcp
User=web

[Install]
WantedBy=multi-user.target
```

Puis pour vérifier j'ai testé de me connecter à l'ip locale de ma VM :  

```
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:57:f0:83 brd ff:ff:ff:ff:ff:ff
    inet 172.28.128.44/24 brd 172.28.128.255 scope global noprefixroute dynamic eth2
       valid_lft 806sec preferred_lft 806sec
    inet6 fe80::a00:27ff:fe57:f083/64 scope link
       valid_lft forever preferred_lft forever
```

![](https://i.imgur.com/cQxny1C.png)

#### B. Sauvegarde

J'ai coupé ton script en 4 :  
* un pour les test
* un pour la sauvegarde
* un pour delete la ou les archives en trop
* un pour stocker variables + fonctions

Au final ça donne ça, après avoir tout préparé (user backup, dossiers et scripts) :  

* backup.service
```
[Unit]
Description=Backup automatique script sauvegarde

[Service]
Environment=PATH1=/srv/site1
Environment=PATH2=/srv/site2
Type=oneshot
ExecStartPre=/opt/backup_test.sh ${PATH1}
ExecStartPre=/opt/backup_test.sh ${PATH2}
ExecStart=/opt/backup_save.sh ${PATH1}
ExecStart=/opt/backup_save.sh ${PATH2}
ExecStartPost=/opt/backup_delete.sh
User=backup

[Install]
WantedBy=multi-user.target
```

* les 4 scripts (test - save - delete - variables)

```bash
#!/bin/bash

source /opt/backup_variables.sh

## PREFLIGHT CHECKS

# Force a specific user to run te script
if [[ ${EUID} -ne ${backup_user_uid} ]]; then
  log "ERROR" "This script must be run as \"${backup_user_name}\" user, which UID is ${backup_user_uid}. Exiting."
  exit 1
fi

# Check that the target dir actually exists and is readable
if [[ ! -d "${target_path}" ]]; then
  log "ERROR" "The target path ${target_path} does not exist. Exiting."
  exit 1
fi
if [[ ! -r "${target_path}" ]]; then
  log "ERROR" "The target path ${target_path} is not readable. Exiting."
  exit 1
fi

# Check that the destination dir actually exists ans is writable
if [[ ! -d "${backup_destination_dir}" ]]; then
  log "ERROR" "The destination dir ${backup_destination_dir} does not exist. Exiting."
  exit 1
fi
if [[ ! -w "${backup_destination_dir}" ]]; then
  log "ERROR" "The destination dir ${backup_destination_dir} is not writable. Exiting."
  exit 1
fi

exit 0
```

```bash
#!/bin/bash

source /opt/backup_variables.sh

# Set the backup user UMASK
umask ${backup_user_umask}

# Backup the site
archive_and_compress "${target_path}"

exit 0
```

```bash
#!/bin/bash

source /opt/backup_variables.sh

# Set the backup user UMASK
umask ${backup_user_umask}

# Rotate backups (only keep the most recent ones)
delete_oldest_backups

exit 0
```

```bash
#!/bin/bash
# it4
# 23/09/2020
# Simple backup script

## VARIABLES

# Colors :D
declare -r NC="\e[0m"
declare -r B="\e[1m"
declare -r RED="\e[31m"
declare -r GRE="\e[32m"

# Target directory : the one we want to backup
declare -r target_path="${1}"
declare -r target_dirname=$(awk -F'/' '{ print $NF }' <<< "${target_path%/}")

# Craft the backup full path and name
declare -r backup_destination_dir="/opt/backup/"
declare -r backup_date="$(date +%y%m%d_%H%M%S)"
declare -r backup_filename="${target_dirname}_${backup_date}.tar.gz"
declare -r backup_destination_path="${backup_destination_dir}/${backup_filename}"

# Informations about the User that must run this script
declare -r backup_user_name="backup"
declare -ri backup_user_uid=1002
declare -ri backup_user_umask=077

# The quantity of backup to keep for each directory
declare -i backups_quantity=7
declare -ri backups_quantity=$((backups_quantity+1))

## FUNCTIONS                                                                                                                                                                                                               

# Get timestamp in order to log
get_current_timestamp() {
  timestamp=$(date "+[%h %d %H:%M:%S]")
}

# Echo arguments with a timestamp
log() {
  log_level="${1}"
  log_message="${2}"

  get_current_timestamp

  if [[ "${log_level}" == "ERROR" ]]; then
    echo -e "${timestamp} ${B}${RED}[ERROR]${NC} ${log_message}" >&2

  elif [[ "${log_level}" == "INFO" ]]; then
    echo -e "${timestamp} ${B}[INFO]${NC} ${log_message}"

  fi
}

# Craft an archive, compress it, and store it in $backup_destination_dir
archive_and_compress() {

  dir_to_backup="${1}"

  log "INFO" "Starting backup."

  # Actually creates the compressed archive
  tar cvzf \
    "${backup_destination_path}" \
    "${dir_to_backup}" \
    --ignore-failed-read &> /dev/null

  # Test if the archive has been created successfully
  if [[ $? -eq 0 ]]
  then
    log "INFO" "${B}${GRE}Success.${NC} Backup ${backup_filename} has been saved to ${backup_destination_dir}."
  else
    log "ERROR" "Backup ${backup_filename} has failed."

    # Even if tar has failed, it creates the archive, so we remove it in case of failure
    rm -f "${backup_destination_path}"

    exit 1
  fi
}

# Delete oldest backups, eg only keep the $backups_quantity most recent backups, for a given directory
delete_oldest_backups() {

  # Get list of oldest backups
  # BE CAREFUL : this only works if there's no IFS character in file names (space, tabs, newlines, etc.)
  oldest_backups=$(ls -tp "${backup_destination_dir}" | grep -v '/$' | grep -E "^${target_dirname}.*$" | tail -n +${backups_quantity})

  if [[ ! -z $oldest_backups ]]
  then

    log "INFO" "This script only keep the ${backups_quantity} most recent backups for a given directory."

    for backup_to_del in ${oldest_backups}
    do
      # This line might be buggy if file names contain IFS characters 
      rm -f "${backup_destination_dir}/${backup_to_del}" &> /dev/null

      if [[ $? -eq 0 ]]
      then
        log "INFO" "${B}${GRE}Success.${NC} Backup ${backup_to_del} has been removed from ${backup_destination_dir}."
      else
        log "[ERROR]" "Deletion of backup ${backup_to_del} from ${backup_destination_dir} has failed."
        exit 1
      fi

    done
  fi
}
```

J'ai aussi créé le timer backup.timer :  

```
[Unit]
Description=Run backup every hour

[Timer]
OnUnitActiveSec=59min


[Install]
WantedBy=timers.target
```

Et enfin le résultat :  

```
[vagrant@tp3 run]$ sudo systemctl list-timers
NEXT                         LEFT       LAST                         PASSED       UNIT                         ACTIVATES
Wed 2020-10-07 19:23:21 UTC  58min left n/a                          n/a          backup.timer                 backup.service
Thu 2020-10-08 16:53:37 UTC  22h left   Wed 2020-10-07 16:53:37 UTC  1h 31min ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service

2 timers listed.
Pass --all to see loaded but inactive timers, too.
[vagrant@tp3 run]$ sudo systemctl status backup.service
● backup.service - Backup automatique script sauvegarde
   Loaded: loaded (/etc/systemd/system/backup.service; disabled; vendor preset: disabled)
   Active: inactive (dead) since Wed 2020-10-07 18:23:21 UTC; 1min 30s ago
  Process: 4797 ExecStartPost=/opt/backup_delete.sh (code=exited, status=0/SUCCESS)
  Process: 4787 ExecStart=/opt/backup_save.sh ${PATH2} (code=exited, status=0/SUCCESS)
  Process: 4777 ExecStart=/opt/backup_save.sh ${PATH1} (code=exited, status=0/SUCCESS)
  Process: 4771 ExecStartPre=/opt/backup_test.sh ${PATH2} (code=exited, status=0/SUCCESS)
  Process: 4766 ExecStartPre=/opt/backup_test.sh ${PATH1} (code=exited, status=0/SUCCESS)
 Main PID: 4787 (code=exited, status=0/SUCCESS)

Oct 07 18:23:21 tp3.b2 systemd[1]: Starting Backup automatique script sauvegarde...
Oct 07 18:23:21 tp3.b2 backup_save.sh[4777]: [Oct 07 18:23:21] [INFO] Starting backup.
Oct 07 18:23:21 tp3.b2 backup_save.sh[4787]: [Oct 07 18:23:21] [INFO] Starting backup.
Oct 07 18:23:21 tp3.b2 backup_delete.sh[4797]: [Oct 07 18:23:21] [INFO] This script only keep the 8 most recent backups for a given directory.        
Oct 07 18:23:21 tp3.b2 backup_delete.sh[4797]: [Oct 07 18:23:21] [INFO] Success. Backup site1_201007_173504.tar.gz has been removed from /opt/backup/.
Oct 07 18:23:21 tp3.b2 systemd[1]: Started Backup automatique script sauvegarde.
```

J'ai essayé de faire un PID file, mais je n'ai pas compris comment me servir du main PID.

## II. Autres features

### 1. Gestion de boot

Même Vagrantfile, mais la box `centos/8`.  

J'ai récupéré mon graphe dans graphe.svg et voilà le résultat sur mon navigateur (noraj de mon dézoomaj) :  

![](https://i.imgur.com/0Qwg4E7.png)

Les trois services les plus lents sont :  

- tuned.service (3.479s)
- sssd.service (2.012s)
- polkit.service (1.153s)

### 2. Gestion de l'heure

```
[vagrant@tp32 ~]$ timedatectl
               Local time: Wed 2020-10-07 18:44:20 UTC
           Universal time: Wed 2020-10-07 18:44:20 UTC
                 RTC time: Wed 2020-10-07 18:44:19    
                Time zone: UTC (UTC, +0000)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

* fuseau horaire actuel :  

```
[vagrant@tp32 ~]$ timedatectl list-timezones | grep -o "Europe/P.*"
Europe/Paris
Europe/Podgorica
Europe/Prague
```

NTP est synchronisé de base.  

* changer le fuseau :  

```
[vagrant@tp32 ~]$ timedatectl set-timezone "Europe/Paris"
==== AUTHENTICATING FOR org.freedesktop.timedate1.set-timezone ====
Authentication is required to set the system timezone.
Authenticating as: root
Password: 
==== AUTHENTICATION COMPLETE ====
[vagrant@tp32 ~]$ timedatectl
               Local time: Wed 2020-10-07 20:56:21 CEST
           Universal time: Wed 2020-10-07 18:56:21 UTC 
                 RTC time: Wed 2020-10-07 18:56:19     
                Time zone: Europe/Paris (CEST, +0200)  
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

### 3. Gestion des noms et de la résolution de nom

* hostname actuel :  

```
[vagrant@tp32 ~]$ hostnamectl
   Static hostname: tp32.b2
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 5e913067f4b64e63b6d11d6284ca4c13
           Boot ID: 903d352ddd354a4890d5af398f91083e
    Virtualization: oracle
  Operating System: CentOS Linux 8 (Core)
       CPE OS Name: cpe:/o:centos:centos:8
            Kernel: Linux 4.18.0-80.el8.x86_64      
      Architecture: x86-64
```

* nouveau hostname :  

```
[vagrant@tp32 ~]$ hostnamectl set-hostname tp3.2.b2
==== AUTHENTICATING FOR org.freedesktop.hostname1.set-static-hostname ====
Authentication is required to set the statically configured local host name, as well as the pretty host name.
Authenticating as: root
Password: 
==== AUTHENTICATION COMPLETE ====
[vagrant@tp32 ~]$ hostnamectl
   Static hostname: tp3.2.b2
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 5e913067f4b64e63b6d11d6284ca4c13
           Boot ID: 903d352ddd354a4890d5af398f91083e
    Virtualization: oracle
  Operating System: CentOS Linux 8 (Core)
       CPE OS Name: cpe:/o:centos:centos:8
            Kernel: Linux 4.18.0-80.el8.x86_64
      Architecture: x86-64
```