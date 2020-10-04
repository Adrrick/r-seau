# TP2 : Déploiement automatisé

## I. Déploiement simple

* Création du vagrantfile

```ruby
Vagrant.configure("2")do|config|
  config.vm.box="centos/7"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false 

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.network "public_network", ip:"192.168.2.11"

  config.vm.hostname = "tp2.vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "TP2_Vagrant"
    vb.memory = "1024"
  end

end
```

Les commandes de vérification :  

```
adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant status
Current machine states:

TP2_Vagrant               running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.

adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant ssh
Last login: Tue Sep 29 08:03:45 2020 from 10.0.2.2

[vagrant@tp2 ~]$ ip a
[...]
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:2d:a0:ab brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.11/24 brd 192.168.2.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe2d:a0ab/64 scope link
       valid_lft forever preferred_lft forever

[vagrant@tp2 ~]$ free -m
              total        used        free      shared  buff/cache   available
Mem:            990          86         813           6          91         785
Swap:          2047           0        2047
```

* Script pour installer vim

J'ai rajouté cette ligne dans le Vagrantfile  

`config.vm.provision "shell", path: "script.sh"`

Voici le script :  

```bash
#!/bin/bash
# 29/09/2020
# Tristan
# auto install vim on boot

sudo yum install -y vim
```

Et le résultat :  

```
adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant up
Bringing machine 'TP2_Vagrant' up with 'virtualbox' provider...
    [...]
==> TP2_Vagrant: Running provisioner: shell...
    TP2_Vagrant: Running: C:/Users/adrik/AppData/Local/Temp/vagrant-shell20200929-4004-ri21sz.sh
    TP2_Vagrant: Loaded plugins: fastestmirror
    TP2_Vagrant: Determining fastest mirrors
    TP2_Vagrant:  * base: centos.mirror.ate.info
    TP2_Vagrant:  * extras: centos.mirror.ate.info
    TP2_Vagrant:  * updates: miroir.univ-paris13.fr
    [...]
    TP2_Vagrant: Complete!
```

Ensuite j'ai rajouté ces lignes dans mon Vagrantfile pour avoir un disque dur de 5go :  

```ruby
CONTROL_NODE_DISK='./tmp/secondDisk.vdi'
[...]
  config.vm.provider "virtualbox" do |vb|
    vb.name = "TP2_Vagrant"
    vb.memory = "1024"
    # Crée le disque, uniquement s'il nexiste pas déjà
    unless File.exist?(CONTROL_NODE_DISK)
      vb.customize ['createhd', '--filename', CONTROL_NODE_DISK, '--variant', 'Fixed', '--size', 5 * 1024]
    end

    # Attache le disque à la VM
    vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', CONTROL_NODE_DISK]
  end
```

Et voici la vérification :  

```
[vagrant@tp2 ~]$ lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  40G  0 disk
└─sda1   8:1    0  40G  0 part /
sdb      8:16   0   5G  0 disk
```

## II. Re-package

J'ai fait toutes les préparations de la box (vim, epel-release, nginx, setenforce 0, systemctl enable firewalld) et ait repackage une box :  

```
adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant package --output centos7-custom.box
==> TP2_Vagrant: Attempting graceful shutdown of VM...
==> TP2_Vagrant: Clearing any previously set forwarded ports...
==> TP2_Vagrant: Exporting VM...
==> TP2_Vagrant: Compressing package to: D:/work_vagrant/vagrant/centos7-custom.box

adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant box add b2-tp2-centos centos7-custom.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'b2-tp2-centos' (v0) for provider: 
    box: Unpacking necessary files from: file://D:/work_vagrant/vagrant/centos7-custom.box
    box:
==> box: Successfully added box 'b2-tp2-centos' (v0) for 'virtualbox'!

adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/vagrant
$ vagrant box list
b2-tp2-centos (virtualbox, 0)
centos/7      (virtualbox, 2004.01)
```

## III. Multi-node deployment

Voici mon Vagrantfile :  

```ruby
Vagrant.configure("2") do |config|
  # Configuration commune à toutes les machines
  config.vm.box = "b2-tp2-centos"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false 

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Config une première VM "node1"
  config.vm.define "node1" do |node1|
    # remarquez l'utilisation de 'node1.' défini sur la ligne au dessus
    node1.vm.network "private_network", ip: "192.168.2.21"
    node1.vm.hostname = "node1.tp2.b2"
    node1.vm.define "node1"
    node1.vm.provider "virtualbox" do |vb|
      vb.name = "node1_tp2"
      vb.memory = "1024"
    end
  end

  # Config une première VM "node2"
  config.vm.define "node2" do |node2|
    # remarquez l'utilisation de 'node2.' défini sur la ligne au dessus
    node2.vm.network "private_network", ip: "192.168.2.22"
    node2.vm.hostname = "node2.tp2.b2"
    node2.vm.define "node2"
    node2.vm.provider "virtualbox" do |vb|
      vb.name = "node2_tp2"
      vb.memory = "512"
    end
  end

end
```

## IV. Automation here we (slowly) come

Voilà le Vagrantfile, puis les deux scripts pour chaque node :  

* Vagrantfile
```ruby
CONTROL_NODE_DISK1='./tmp/secondDisk1.vdi'
CONTROL_NODE_DISK2='./tmp/secondDisk2.vdi'

Vagrant.configure("2") do |config|

  config.vm.box = "b2-tp2-centos"

  config.vbguest.auto_update = false

  config.vm.box_check_update = false 

  config.vm.synced_folder ".", "/vagrant", disabled: true
  

  
  # Config une première VM "node1"
  config.vm.define "node1" do |node1|
    node1.vm.network "public_network", ip: "192.168.1.11"
    node1.vm.network "private_network", type: "dhcp"
    node1.vm.hostname = "node1.tp2.b2"
    node1.vm.define "node1"
    node1.vm.provision "shell", path: "script_node1.sh" 
    node1.vm.provider "virtualbox" do |vb|
      vb.name = "node1_tp2"
      vb.memory = "2048"
      unless File.exist?(CONTROL_NODE_DISK1)
        vb.customize ['createhd', '--filename', CONTROL_NODE_DISK1, '--variant', 'Fixed', '--size', 5 * 1024]
      end
      vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', CONTROL_NODE_DISK1]
    end
  end

  # Config une première VM "node2"
  config.vm.define "node2" do |node2|
    node2.vm.network "public_network", ip: "192.168.1.12"
    node2.vm.network "private_network", type: "dhcp"
    node2.vm.hostname = "node2.tp2.b2"
    node2.vm.define "node2"
    node2.vm.provision "shell", path: "script_node2.sh"
    node2.vm.provider "virtualbox" do |vb|
      vb.name = "node2_tp2"
      vb.memory = "2048"
      unless File.exist?(CONTROL_NODE_DISK2)
        vb.customize ['createhd', '--filename', CONTROL_NODE_DISK2, '--variant', 'Fixed', '--size', 5 * 1024]
      end
      vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', CONTROL_NODE_DISK2]    
    end
  end

end

```

* node1
```bash
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
```

* node 2
```bash
#!/bin/bash
# 30/09/2020
# Tristan
# node2 auto config

setenforce 0
systemctl start firewalld
echo "192.168.1.11    node1.tp2.b2" >> /etc/hosts
useradd admin
echo "admin" | passwd --stdin admin
echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers
echo -n | openssl s_client -connect node1.tp2.b2:443 \
    | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/pki/ca-trust/source/anchors/server.cert
update-ca-trust
```