# Maîtrise de poste - Day 1

## Host OS

```
PS C:\Users\adrik> wmic OS get CSName,Name,Version
CSName           Name                                                                  Version
LAPTOP-31O3RQGM  Microsoft Windows 10 Famille|C:\windows|\Device\Harddisk1\Partition3  10.0.17763

PS C:\Users\adrik> wmic CPU get Name,DataWidth
DataWidth  Name
64         Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz

PS C:\Users\adrik> wmic MEMORYCHIP get Capacity,Manufacturer
Capacity    Manufacturer
8589934592  SK Hynix
```

## Devices

(Toujours au même endroit)

Processeur : Processeur	Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz 
Processeur Intel génération 5 haut de gamme (le premier chiffre est gros), série mobile biocoeur basse consommation pour Ultrabook.  

Touchpad : Synaptics SMBus TouchPad  

(Gestionnaire de périphériques)  

Enceintes : Realtek High Definition Audio  
Microphone : Realtek High Definition Audio

```
PS C:\Users\adrik> wmic diskdrive GET Name,Manufacturer,Size,Status,Partitions
Manufacturer                   Name                Partitions  Size           Status
(Lecteurs de disque standard)  \\.\PHYSICALDRIVE0  1           1000202273280  OK
(Lecteurs de disque standard)  \\.\PHYSICALDRIVE1  3           128034708480   OK
```

Il y a une partition sur le C, il y a 3 partitions sur le D à cause des VM (nottament une sur VMware)

## Network

```
PS C:\Users\adrik> ipconfig /all

Configuration IP de Windows

   Nom de l’hôte . . . . . . . . . . : LAPTOP-31O3RQGM
   Suffixe DNS principal . . . . . . :
   Type de noeud. . . . . . . . . .  : Mixte
   Routage IP activé . . . . . . . . : Oui
   Proxy WINS activé . . . . . . . . : Non
   Liste de recherche du suffixe DNS.: lan

Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Realtek PCIe GbE Family Controller
   Adresse physique . . . . . . . . . . . : B0-0C-D1-51-44-46
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui

Carte Ethernet VirtualBox Host-Only Network :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-09
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::4908:39de:a1dd:4552%9(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.3.1.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 1007288359
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte Ethernet VirtualBox Host-Only Network #2 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #2
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-0F
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::d465:655a:650a:7d54%15(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.225.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 1091174439
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte Ethernet VirtualBox Host-Only Network #3 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #3
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-16
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::50d1:5b64:a3cc:1677%22(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.3.2.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 1191837735
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte Ethernet VirtualBox Host-Only Network #4 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter #4
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-12
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9467:4fb8:608:286b%18(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.197.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 1275723815
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte réseau sans fil Connexion au réseau local* 1 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter
   Adresse physique . . . . . . . . . . . : 0E-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui

Carte réseau sans fil Connexion au réseau local* 10 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter #2
   Adresse physique . . . . . . . . . . . : 8E-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui

Carte Ethernet VMware Network Adapter VMnet1 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VMware Virtual Ethernet Adapter for VMnet1
   Adresse physique . . . . . . . . . . . : 00-50-56-C0-00-01
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9073:b7ea:8cad:a60e%12(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.8.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 83906646
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte Ethernet VMware Network Adapter VMnet8 :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VMware Virtual Ethernet Adapter for VMnet8
   Adresse physique . . . . . . . . . . . : 00-50-56-C0-00-08
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::dd96:2dd7:653a:f3e2%24(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.80.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 167792726
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : lan
   Description. . . . . . . . . . . . . . : Realtek RTL8822BE 802.11ac PCIe Adapter
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%23(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.1.13(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Bail obtenu. . . . . . . . . . . . . . : mardi 14 avril 2020 11:25:43
   Bail expirant. . . . . . . . . . . . . : mercredi 15 avril 2020 11:25:42
   Passerelle par défaut. . . . . . . . . : 192.168.1.254
   Serveur DHCP . . . . . . . . . . . . . : 192.168.1.254
   IAID DHCPv6 . . . . . . . . . . . : 151820006
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : 192.168.1.254
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé

Carte Ethernet Connexion réseau Bluetooth :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Bluetooth Device (Personal Area Network)
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-58
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
```

- Carte Ethernet : accès à Internet  
- Cartes Ethernet Virtualbox Host-only Network Adaptater : les réseaux host-only des VM Virtualbox  
- Cartes Ethernet VMware Network Adaptater : l'accès internet aux VM sur VMware  
- Carte réseau sans fil Wi-Fi : accès à Internet  
- Carte Ethernet Connexion réseau Bluetooth : accès Bluetooth aux périphériques Bluetooth  

Ports TCP / UDP en utilisation :  

```
PS C:\windows\system32> netstat -a -b

Connexions actives

  Proto  Adresse locale         Adresse distante       État
  TCP    127.0.0.1:55991        LAPTOP-31O3RQGM:65001  ESTABLISHED
 [nvcontainer.exe]
  TCP    127.0.0.1:65001        LAPTOP-31O3RQGM:55991  ESTABLISHED
 [nvcontainer.exe]
  TCP    192.168.1.13:56195     52.236.190.14:https    ESTABLISHED
 [vsls-agent.exe]
  TCP    192.168.1.13:56764     40.67.254.36:https     ESTABLISHED
  WpnService
 [svchost.exe]
  TCP    192.168.1.13:56826     40.69.216.251:https    ESTABLISHED
 Impossible d’obtenir les informations de propriétaire
  TCP    192.168.1.13:56827     40.69.221.239:https    ESTABLISHED
 [jhi_service.exe]
  UDP    0.0.0.0:500            *:*
  IKEEXT
 [svchost.exe]
  UDP    0.0.0.0:4500           *:*
  IKEEXT
 [svchost.exe]
  UDP    0.0.0.0:5050           *:*
  CDPSvc
 [svchost.exe]
  UDP    0.0.0.0:5353           *:*
  Dnscache
 [svchost.exe]
  UDP    0.0.0.0:5355           *:*
  Dnscache
 [svchost.exe]
  UDP    0.0.0.0:63385          *:*
 [nvcontainer.exe]
  UDP    10.3.1.1:137           *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    10.3.1.1:138           *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    10.3.1.1:1900          *:*
  SSDPSRV
 [svchost.exe]
  UDP    10.3.1.1:2177          *:*
  QWAVE
 [svchost.exe]
  UDP    10.3.1.1:5353          *:*
 [nvcontainer.exe]
  UDP    10.3.1.1:51491         *:*
  SSDPSRV
 [svchost.exe]
  UDP    10.3.2.1:137           *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    10.3.2.1:138           *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    10.3.2.1:1900          *:*
  SSDPSRV
 [svchost.exe]
  UDP    10.3.2.1:2177          *:*
  QWAVE
 [svchost.exe]
  UDP    10.3.2.1:5353          *:*
 [nvcontainer.exe]
  UDP    10.3.2.1:51493         *:*
  SSDPSRV
 [svchost.exe]
  UDP    127.0.0.1:1900         *:*
  SSDPSRV
 [svchost.exe]
  UDP    127.0.0.1:48701        *:*
 [NVIDIA Web Helper.exe]
  UDP    127.0.0.1:51481        *:*
 [nvcontainer.exe]
  UDP    127.0.0.1:51482        *:*
 [nvcontainer.exe]
  UDP    127.0.0.1:51498        *:*
  SSDPSRV
 [svchost.exe]
  UDP    127.0.0.1:52919        *:*
 [NVIDIA Web Helper.exe]
  UDP    127.0.0.1:52920        *:*
 [NVIDIA Web Helper.exe]
  UDP    127.0.0.1:55723        *:*
  iphlpsvc
 [svchost.exe]
  UDP    127.0.0.1:55724        *:*
 [nvcontainer.exe]
  UDP    127.0.0.1:55725        *:*
 [nvcontainer.exe]
  UDP    127.0.0.1:55726        *:*
 [nvcontainer.exe]
  UDP    127.0.0.1:60973        *:*
 [NVIDIA Web Helper.exe]
  UDP    127.0.0.1:60974        *:*
 [NVIDIA Web Helper.exe]
  UDP    127.0.0.1:65000        *:*
 [nvcontainer.exe]
  UDP    192.168.1.13:137       *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.1.13:138       *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.1.13:1900      *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.1.13:2177      *:*
  QWAVE
 [svchost.exe]
  UDP    192.168.1.13:5353      *:*
 [nvcontainer.exe]
  UDP    192.168.1.13:51497     *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.8.1:137        *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.8.1:138        *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.8.1:1900       *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.8.1:2177       *:*
  QWAVE
 [svchost.exe]
  UDP    192.168.8.1:5353       *:*
 [nvcontainer.exe]
  UDP    192.168.8.1:51495      *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.80.1:137       *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.80.1:138       *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.80.1:1900      *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.80.1:2177      *:*
  QWAVE
 [svchost.exe]
  UDP    192.168.80.1:5353      *:*
 [nvcontainer.exe]
  UDP    192.168.80.1:51496     *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.197.1:137      *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.197.1:138      *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.197.1:1900     *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.197.1:2177     *:*
  QWAVE
 [svchost.exe]
  UDP    192.168.197.1:5353     *:*
 [nvcontainer.exe]
  UDP    192.168.197.1:51494    *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.225.1:137      *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.225.1:138      *:*
 Impossible d’obtenir les informations de propriétaire
  UDP    192.168.225.1:1900     *:*
  SSDPSRV
 [svchost.exe]
  UDP    192.168.225.1:2177     *:*
  QWAVE
 [svchost.exe]
  UDP    192.168.225.1:5353     *:*
 [nvcontainer.exe]
  UDP    192.168.225.1:51492    *:*
  SSDPSRV
 [svchost.exe]
  UDP    [::]:500               *:*
  IKEEXT
 [svchost.exe]
  UDP    [::]:4500              *:*
  IKEEXT
 [svchost.exe]
  UDP    [::]:5353              *:*
  Dnscache
 [svchost.exe]
  UDP    [::]:5355              *:*
  Dnscache
 [svchost.exe]
  UDP    [::]:63386             *:*
 [nvcontainer.exe]
  UDP    [::1]:1900             *:*
  SSDPSRV
 [svchost.exe]
  UDP    [::1]:5353             *:*
 [nvcontainer.exe]
  UDP    [::1]:51490            *:*
  SSDPSRV
 [svchost.exe]
  UDP    [::1]:56732            *:*
  RemoteAccess
 [svchost.exe]
  UDP    [::1]:56733            *:*
  RemoteAccess
 [svchost.exe]
  UDP    [fe80::4908:39de:a1dd:4552%9]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::4908:39de:a1dd:4552%9]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::4908:39de:a1dd:4552%9]:51483  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::50d1:5b64:a3cc:1677%22]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::50d1:5b64:a3cc:1677%22]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::50d1:5b64:a3cc:1677%22]:51485  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9073:b7ea:8cad:a60e%12]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9073:b7ea:8cad:a60e%12]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::9073:b7ea:8cad:a60e%12]:51487  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9467:4fb8:608:286b%18]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9467:4fb8:608:286b%18]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::9467:4fb8:608:286b%18]:51486  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9d49:b2a7:936b:b3df%23]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::9d49:b2a7:936b:b3df%23]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::9d49:b2a7:936b:b3df%23]:51489  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::d465:655a:650a:7d54%15]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::d465:655a:650a:7d54%15]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::d465:655a:650a:7d54%15]:51484  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::dd96:2dd7:653a:f3e2%24]:1900  *:*
  SSDPSRV
 [svchost.exe]
  UDP    [fe80::dd96:2dd7:653a:f3e2%24]:2177  *:*
  QWAVE
 [svchost.exe]
  UDP    [fe80::dd96:2dd7:653a:f3e2%24]:51488  *:*
  SSDPSRV
 [svchost.exe]
```

- nvcontainer.exe : pour les pilotes Nvidia, appartient au NVIDIA Display Control Panel
- svchost.exe : processus générique de Windows qui sert d'hôte pour les autres processus, il y a autant de svchost que de processus qui s'en servent
- vsls-agent.exe : pour Visual Studio Live Share, sert à permettre la connexion sur nous
- jhi_service.exe : composant logiciel de Intel® Management Engine Components de Intel Corporation (Intel® JOM Dynamic Application Loader Host Interface Service)
- NVIDIA Web Helper.exe : processus appartenant à Node.js

## Users

```
PS C:\Users\adrik> Get-LocalUser

Name               Enabled Description
----               ------- -----------
Administrateur     False   Compte d’utilisateur d’administration
adrik              True
DefaultAccount     False   Compte utilisateur géré par le système.
Invité             False   Compte d’utilisateur invité
WDAGUtilityAccount False   Compte d’utilisateur géré et utilisé par le système pour les scénarios Windows Defender A...
YNOV01             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV02             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV03             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV04             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV05             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV06             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV07             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV08             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV09             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV10             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV11             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV12             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV13             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV14             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV15             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV16             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV17             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV18             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV19             True    Local user account for execution of R scripts in SQL Server instance YNOV
YNOV20             True    Local user account for execution of R scripts in SQL Server instance YNOV
```

On peut voir que l'utilisateur full admin est Administrateur.

## Processus

```
PS C:\Users\adrik> tasklist

Nom de l’image                 PID Nom de la sessio Numéro de s Utilisation
========================= ======== ================ =========== ============
System Idle Process              0 Services                   0         8 Ko
System                           4 Services                   0        24 Ko
Registry                       120 Services                   0    36 632 Ko
smss.exe                       400 Services                   0       440 Ko
csrss.exe                      712 Services                   0     2 124 Ko
wininit.exe                    812 Services                   0     2 600 Ko
services.exe                   884 Services                   0     6 220 Ko
lsass.exe                      904 Services                   0    12 868 Ko
svchost.exe                     88 Services                   0     1 016 Ko
svchost.exe                    432 Services                   0    21 600 Ko
fontdrvhost.exe                504 Services                   0       680 Ko
WUDFHost.exe                   508 Services                   0     4 464 Ko
svchost.exe                   1040 Services                   0    12 344 Ko
svchost.exe                   1096 Services                   0     5 788 Ko
svchost.exe                   1384 Services                   0     4 820 Ko
svchost.exe                   1444 Services                   0     6 640 Ko
svchost.exe                   1452 Services                   0     3 188 Ko
svchost.exe                   1548 Services                   0     5 580 Ko
svchost.exe                   1656 Services                   0     2 112 Ko
svchost.exe                   1664 Services                   0     4 544 Ko
svchost.exe                   1856 Services                   0    11 808 Ko
svchost.exe                   1968 Services                   0     6 896 Ko
svchost.exe                   1984 Services                   0     3 456 Ko
svchost.exe                   1060 Services                   0    10 916 Ko
svchost.exe                   1168 Services                   0     3 780 Ko
TouchpointAnalyticsClient     1152 Services                   0    26 448 Ko
svchost.exe                   2028 Services                   0     2 888 Ko
svchost.exe                   2080 Services                   0     5 060 Ko
svchost.exe                   2196 Services                   0     1 932 Ko
svchost.exe                   2252 Services                   0     7 664 Ko
svchost.exe                   2340 Services                   0     3 460 Ko
svchost.exe                   2376 Services                   0     8 880 Ko
svchost.exe                   2392 Services                   0     1 948 Ko
svchost.exe                   2444 Services                   0     5 520 Ko
svchost.exe                   2516 Services                   0     5 520 Ko
svchost.exe                   2544 Services                   0    23 056 Ko
svchost.exe                   2632 Services                   0     5 976 Ko
svchost.exe                   2700 Services                   0    11 976 Ko
svchost.exe                   2828 Services                   0     4 920 Ko
svchost.exe                   2976 Services                   0     3 748 Ko
svchost.exe                   3196 Services                   0     4 376 Ko
WmiPrvSE.exe                  3292 Services                   0     5 564 Ko
unsecapp.exe                  3424 Services                   0     3 228 Ko
SynTPEnhService.exe           3656 Services                   0     2 704 Ko
NVDisplay.Container.exe       3704 Services                   0     5 716 Ko
svchost.exe                   3760 Services                   0     1 652 Ko
svchost.exe                   3768 Services                   0     6 408 Ko
svchost.exe                   3776 Services                   0     4 844 Ko
igfxCUIService.exe            3860 Services                   0     2 764 Ko
Memory Compression            3880 Services                   0   255 964 Ko
svchost.exe                   3944 Services                   0     2 576 Ko
svchost.exe                   3952 Services                   0    10 248 Ko
svchost.exe                   2864 Services                   0     2 300 Ko
svchost.exe                   4108 Services                   0     8 688 Ko
RtkAudioService64.exe         4192 Services                   0     2 732 Ko
svchost.exe                   4432 Services                   0     5 888 Ko
svchost.exe                   4436 Services                   0     2 316 Ko
svchost.exe                   4540 Services                   0     8 700 Ko
svchost.exe                   4604 Services                   0     6 636 Ko
wlanext.exe                   4628 Services                   0     4 072 Ko
conhost.exe                   4644 Services                   0     1 008 Ko
spoolsv.exe                   4792 Services                   0     3 988 Ko
svchost.exe                   4892 Services                   0    12 580 Ko
svchost.exe                   5068 Services                   0     2 896 Ko
svchost.exe                   5084 Services                   0    27 920 Ko
RstMwService.exe              5108 Services                   0     1 892 Ko
RtkBtManServ.exe              5116 Services                   0     2 676 Ko
svchost.exe                   4032 Services                   0     1 600 Ko
IntelCpHDCPSvc.exe            4148 Services                   0     1 492 Ko
NvTelemetryContainer.exe      4296 Services                   0     3 628 Ko
svchost.exe                   4312 Services                   0     6 844 Ko
esif_uf.exe                   4316 Services                   0     1 080 Ko
nvcontainer.exe               4336 Services                   0    10 236 Ko
svchost.exe                   4472 Services                   0    29 804 Ko
svchost.exe                   4656 Services                   0     2 556 Ko
svchost.exe                   4920 Services                   0     1 496 Ko
svchost.exe                   4980 Services                   0     1 796 Ko
sqlwriter.exe                 5136 Services                   0     1 700 Ko
svchost.exe                   5252 Services                   0     3 616 Ko
vmware-authd.exe              5260 Services                   0     4 012 Ko
vmnetdhcp.exe                 5276 Services                   0     1 048 Ko
svchost.exe                   5288 Services                   0    12 944 Ko
vmnat.exe                     5296 Services                   0     2 116 Ko
WildTangentHelperService.     5372 Services                   0     8 388 Ko
vmware-usbarbitrator64.ex     5380 Services                   0     2 908 Ko
MsMpEng.exe                   5396 Services                   0   213 508 Ko
IntelCpHeciSvc.exe            5768 Services                   0     1 524 Ko
svchost.exe                   5796 Services                   0     1 856 Ko
sqlceip.exe                   6120 Services                   0    17 592 Ko
sqlservr.exe                  6128 Services                   0    84 104 Ko
ReportingServicesService.     6140 Services                   0    45 780 Ko
Microsoft.ReportingServic     6872 Services                   0     6 264 Ko
conhost.exe                   6904 Services                   0       928 Ko
svchost.exe                   7052 Services                   0     6 924 Ko
svchost.exe                   7388 Services                   0     7 600 Ko
fdlauncher.exe                7756 Services                   0       840 Ko
Launchpad.exe                 7788 Services                   0     4 640 Ko
fdhost.exe                    7844 Services                   0       968 Ko
conhost.exe                   7852 Services                   0       804 Ko
svchost.exe                   7920 Services                   0     3 312 Ko
SearchIndexer.exe             2204 Services                   0    45 544 Ko
NisSrv.exe                    8384 Services                   0     7 184 Ko
dllhost.exe                   8632 Services                   0     1 996 Ko
svchost.exe                   8960 Services                   0     3 124 Ko
dllhost.exe                   5020 Services                   0     3 016 Ko
PresentationFontCache.exe     6420 Services                   0     2 648 Ko
svchost.exe                   9376 Services                   0    11 884 Ko
svchost.exe                   9556 Services                   0     2 824 Ko
svchost.exe                  10136 Services                   0    13 244 Ko
svchost.exe                   3508 Services                   0     3 744 Ko
svchost.exe                   9912 Services                   0     8 456 Ko
svchost.exe                  11368 Services                   0     9 676 Ko
svchost.exe                  11440 Services                   0    19 716 Ko
svchost.exe                  12872 Services                   0     6 288 Ko
SecurityHealthService.exe    13664 Services                   0     7 576 Ko
svchost.exe                  14536 Services                   0     4 700 Ko
svchost.exe                  17024 Services                   0    12 856 Ko
svchost.exe                  15980 Services                   0    12 844 Ko
svchost.exe                  11916 Services                   0     4 692 Ko
HPCommRecovery.exe           12168 Services                   0    20 812 Ko
HPJumpStartBridge.exe        11524 Services                   0     5 380 Ko
IAStorDataMgrSvc.exe         12788 Services                   0    38 740 Ko
jhi_service.exe              16440 Services                   0     1 024 Ko
SgrmBroker.exe               12596 Services                   0     3 516 Ko
svchost.exe                   6000 Services                   0     2 604 Ko
svchost.exe                  14556 Services                   0     4 628 Ko
svchost.exe                  10700 Services                   0     4 444 Ko
SysInfoCap.exe               13480 Services                   0    18 144 Ko
AppHelperCap.exe              3848 Services                   0    11 332 Ko
NetworkCap.exe               14608 Services                   0     8 064 Ko
csrss.exe                    17272 Console                    6     5 132 Ko
winlogon.exe                 10116 Console                    6    11 500 Ko
fontdrvhost.exe               3412 Console                    6     4 584 Ko
dwm.exe                       2112 Console                    6    51 336 Ko
NVDisplay.Container.exe       9072 Console                    6    23 100 Ko
svchost.exe                  17268 Services                   0     4 540 Ko
nvcontainer.exe              11352 Console                    6    20 072 Ko
sihost.exe                   14076 Console                    6    25 604 Ko
svchost.exe                   4960 Console                    6    21 472 Ko
svchost.exe                  10084 Console                    6     6 808 Ko
svchost.exe                  17492 Console                    6    29 040 Ko
igfxEM.exe                   18172 Console                    6    21 344 Ko
taskhostw.exe                 9984 Console                    6    13 068 Ko
HPJumpStartLaunch.exe         1428 Console                    6       632 Ko
explorer.exe                 15860 Console                    6   470 332 Ko
svchost.exe                   3384 Console                    6    15 428 Ko
svchost.exe                  17588 Services                   0     6 248 Ko
ShellExperienceHost.exe      13216 Console                    6    50 020 Ko
SettingSyncHost.exe          11568 Console                    6     5 416 Ko
SearchUI.exe                 13792 Console                    6    80 988 Ko
SynTPEnh.exe                 10396 Console                    6    26 060 Ko
RuntimeBroker.exe            11876 Console                    6    17 952 Ko
ctfmon.exe                    4972 Console                    6    13 976 Ko
RuntimeBroker.exe             2928 Console                    6    28 072 Ko
NVIDIA Web Helper.exe        13024 Console                    6     1 952 Ko
conhost.exe                   9636 Console                    6       720 Ko
RuntimeBroker.exe            16500 Console                    6    16 284 Ko
SynTPHelper.exe               5344 Console                    6     5 556 Ko
smartscreen.exe               8732 Console                    6    20 676 Ko
SecurityHealthSystray.exe     1284 Console                    6     6 816 Ko
RtkNGUI64.exe                10224 Console                    6    10 812 Ko
RtlS5Wake.exe                  808 Console                    6    10 288 Ko
CCleaner64.exe                4052 Console                    6    19 392 Ko
wallpaper32.exe               4212 Console                    6    64 400 Ko
EpicGamesLauncher.exe         3000 Console                    6    52 508 Ko
UnrealCEFSubProcess.exe      12064 Console                    6    21 524 Ko
HPSystemEventUtilityHost.     6592 Console                    6    48 964 Ko
HPAudioSwitch.exe             3248 Console                    6    30 788 Ko
IAStorIcon.exe                5200 Console                    6    32 396 Ko
Code.exe                      7904 Console                    6    60 352 Ko
Code.exe                     17732 Console                    6    99 024 Ko
Code.exe                     10220 Console                    6    21 116 Ko
Code.exe                     15756 Console                    6   169 868 Ko
Code.exe                      7608 Console                    6     9 764 Ko
Code.exe                     15972 Console                    6    70 020 Ko
Code.exe                      3968 Console                    6    56 636 Ko
conhost.exe                  10376 Console                    6     4 788 Ko
vsls-agent.exe                1680 Console                    6    38 024 Ko
svchost.exe                  13400 Console                    6     9 900 Ko
ApplicationFrameHost.exe      7836 Console                    6    23 360 Ko
MicrosoftEdge.exe             2388 Console                    6     5 128 Ko
browser_broker.exe            9688 Console                    6     6 628 Ko
RuntimeBroker.exe            17072 Console                    6     6 140 Ko
MicrosoftEdgeCP.exe           9324 Console                    6    19 756 Ko
MicrosoftEdgeSH.exe           7908 Console                    6     6 276 Ko
SystemSettings.exe            1800 Console                    6       272 Ko
Microsoft.Photos.exe         15204 Console                    6        56 Ko
dllhost.exe                  12664 Console                    6     9 928 Ko
powershell.exe                6452 Console                    6    65 064 Ko
conhost.exe                  15168 Console                    6    13 796 Ko
Video.UI.exe                 14860 Console                    6        60 Ko
CompPkgSrv.exe                5496 Console                    6     7 888 Ko
RuntimeBroker.exe            12160 Console                    6    27 340 Ko
audiodg.exe                   1764 Services                   0    34 236 Ko
WindowsInternal.Composabl    13904 Console                    6    35 656 Ko
SearchProtocolHost.exe        9704 Console                    6     7 364 Ko
svchost.exe                  17980 Services                   0     8 340 Ko
YourPhone.exe                 3716 Console                    6    35 496 Ko
RuntimeBroker.exe            18348 Console                    6     7 428 Ko
SearchFilterHost.exe          1592 Services                   0     6 196 Ko
SearchProtocolHost.exe        7592 Services                   0    12 000 Ko
WmiPrvSE.exe                   200 Services                   0     9 356 Ko
tasklist.exe                 11952 Console                    6     7 648 Ko
```

- svchost.exe : sans ça y'a pas de processus
- System : gère la mémoire et la mémoire compressée du kernel, host la plupart des drivers (network, disque, USB...)
- Registry : base de donnée utilisée par Windows contenant les données de config du système et de ce qui est installé dessus
- wininit.exe : Windows Start-Up Application, permet de boot Windows
- services.exe : responsable de démarrer et arrêter les services du système

## Scripting

J'ai choisi d'utiliser Powershell vu que c'est le meilleur terminal sous Windows (je te regarde invité de commande)

```
wmic os get CSName,Name,Version /value
wmic nicconfig GET IPADDRESS,ServiceName | findstr "RTWlanE"
systeminfo | Select-String "Heure de démarrage","Mémoire physique totale","Mémoire physique disponible"
Get-LocalUser
```