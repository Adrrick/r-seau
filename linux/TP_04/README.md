# TP4 : Déploiement multi-noeud

## 0. Prerequisites

```
adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/tp4
$ vagrant package --output b2-tp4-centos.box
==> default: Attempting graceful shutdown of VM...
==> default: Clearing any previously set forwarded ports...
==> default: Exporting VM...
==> default: Compressing package to: D:/work_vagrant/tp4/b2-tp4-centos.box

adrik@LAPTOP-31O3RQGM MINGW64 /d/work_vagrant/tp4
$ vagrant box add b2-tp4-centos b2-tp4-centos.box
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'b2-tp4-centos' (v0) for provider: 
    box: Unpacking necessary files from: file://D:/work_vagrant/tp4/b2-tp4-centos.box
    box:
==> box: Successfully added box 'b2-tp4-centos' (v0) for 'virtualbox'!
```

## I. Consignes générales

| Name          | IP (public)  | IP (private) | Rôle    |
| ------------- | ------------ | ------------ | ------- |
| stack.gitea   | 192.168.1.11 | 192.168.1.21 | Gitea   |
| stack.mariadb | 192.168.1.12 | 192.168.1.22 | MariaDB |
| stack.nginx   | 192.168.1.13 | 192.168.1.23 | Nginx   |
| stack.nfs     | 192.168.1.14 | 192.168.1.24 | NFS     |

Je t'invite à aller voir le vagrantfile et les scripts pour voir ce qui a été fait.