# TP 01

# I. Exploration locale en solo

## 1. Affichage d'informations sur la pile TCP/IP locale

**En ligne de commandes**

* **Cartes réseau**

PS C:\Users\adrik> ipconfig /all

```
Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : Realtek PCIe GbE Family Controller
   Adresse MAC ----> Adresse physique . . . . . . . . . . . : B0-0C-D1-51-44-46 
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
```
* La carte ethernet n'a pas d'IP car je ne suis pas branché

[...]
```
Carte réseau sans fil Wi-Fi :  <--- nom

   Suffixe DNS propre à la connexion. . . : auvence.co
   Description. . . . . . . . . . . . . . : Realtek RTL8822BE 802.11ac PCIe Adapter
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-57  <--- adresse MAC
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%19(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.1.36(préféré)  <--- adresse IPv4
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : jeudi 16 janvier 2020 13:50:15
   Bail expirant. . . . . . . . . . . . . : jeudi 16 janvier 2020 16:25:50
   Passerelle par défaut. . . . . . . . . : 10.33.3.253
   Serveur DHCP . . . . . . . . . . . . . : 10.33.3.254
   IAID DHCPv6 . . . . . . . . . . . : 151820006
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : 10.33.10.20
                                       10.33.10.2
                                       8.8.8.8
                                       8.8.4.4
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```

* **Gateway**

PS C:\Users\adrik> netstat -nr

[...]
```
IPv4 Table de routage
===========================================================================
Itinéraires actifs :
Destination réseau    Masque réseau    Adr. passerelle   Adr. interface   Métrique
          0.0.0.0          0.0.0.0      10.33.3.253       10.33.1.36       50
```
[...]

**En graphique**


Windows/Panneau de configuration/Réseau et Internet/Centre réseau et partage/Modifier les paramètres de la carte/Wi-fi/Détails...
```
Suffixe DNS propre à la connexion: auvence.co
Description: Realtek RTL8822BE 802.11ac PCIe Adapter
Adresse physique: ‎0C-96-E6-AC-ED-57  <--- adresse MAC
DHCP activé: Oui
Adresse IPv4: 10.33.1.36  <--- adresse IP
Masque de sous-réseau IPv4: 255.255.252.0
Bail obtenu: jeudi 16 janvier 2020 13:50:14
Bail expirant: jeudi 16 janvier 2020 16:25:49
Passerelle par défaut IPv4: 10.33.3.253  <--- gateway
Serveur DHCP IPv4: 10.33.3.254
Serveurs DNS IPv4: 10.33.10.20, 10.33.10.2, 8.8.8.8, 8.8.4.4
Serveur WINS IPv4: 
NetBIOS sur TCP/IP activé: Oui
Adresse IPv6 locale de lien: fe80::9d49:b2a7:936b:b3df%19
Passerelle par défaut IPv6: 
Serveur DNS IPv6:
```
**A quoi sert la gateway d'Ynov ?**
Elle permet aux personnes connectées au réseau d'Ynov d'en sortir et se connecter sur d'autres réseaux, pour se connecter aux serveurs de google par exemple.

## 2. Modification des informations

**A. Modification d'adresse IP (part 1)**

```
Windows/Panneau de configuration/Réseau et Internet/Centre réseau et partage/Modifier les paramètres de la carte/Wi-fi/Propriétés/Protocole internet version 4 (TCP/IPv4)

Utiliser l'adresse IP suivante :

Adresse IP : 10.33.1.250
Masque de sous-réseau : 255.255.252.0
Passerelle par défaut : 10.33.3.253
```
**Pourquoi on peut perdre l'accès à internet ?**
On peut avoir entré une adresse IP déjà prise.

**C. Modification d'adresse IP (part 2)**

```
nmap -sP 10.33.0.0/22

[...]

MAC Address: D8:5D:E2:11:06:85 (Hon Hai Precision Ind.)
Nmap scan report for 10.33.0.88
Host is up (0.013s latency).

MAC Address: 28:3F:69:C3:18:DE (Sony Mobile Communications)
Nmap scan report for 10.33.0.94
Host is up (0.0050s latency).

MAC Address: D0:57:7B:AF:70:7B (Intel Corporate)
Nmap scan report for 10.33.0.98
Host is up (0.17s latency).

[...]
```

J'ai repéré la 10.33.0.95 comme libre.
```
Windows/Panneau de configuration/Réseau et Internet/Centre réseau et partage/Modifier les paramètres de la carte/Wi-fi/Propriétés/Protocole internet version 4 (TCP/IPv4)

Adresse IP : 10.33.0.95
Masque de sous-réseau : 255.255.252.0
Passerelle par défaut : 10.33.3.253
```
Après avoir regardé les détails :
```
Suffixe DNS propre à la connexion: 
Description: Realtek RTL8822BE 802.11ac PCIe Adapter
Adresse physique: ‎0C-96-E6-AC-ED-57
DHCP activé: Non
Adresse IPv4: 10.33.0.95  <--- adresse IPv4
Masque de sous-réseau IPv4: 255.255.252.0
Passerelle par défaut IPv4: 10.33.3.253
Serveurs DNS IPv4: 8.8.8.8, 8.8.4.4
Serveur WINS IPv4: 
NetBIOS sur TCP/IP activé: Oui
Adresse IPv6 locale de lien: fe80::9d49:b2a7:936b:b3df%19
Passerelle par défaut IPv6: 
Serveur DNS IPv6:
```
# II. Exploration locale en duo

## 3. Modification d'adresse IP


```
PS C:\Users\adrik> ping 192.168.137.1

Envoi d’une requête 'Ping'  192.168.137.1 avec 32 octets de données :
Réponse de 192.168.137.1 : octets=32 temps=2 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=1 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=2 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=2 ms TTL=128

Statistiques Ping pour 192.168.137.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 2ms, Moyenne = 1ms
```
## 4. Utilisation d'un des deux comme gateway

J'ai désactivé ma wi-fi pour utiliser le PC de Quentin en gateway.

```
PS C:\Users\adrik> nslookup wikipedia.com

Serveur :   dns.google
Address:  8.8.8.8

Réponse ne faisant pas autorité :
Nom :    wikipedia.com
Addresses:  2620:0:862:ed1a::3
          91.198.174.194
```

J'ai ensuite essayé un tracert.

```
PS C:\Users\adrik> tracert google.com

Détermination de l’itinéraire vers google.com [216.58.209.238]
avec un maximum de 30 sauts :

  1     2 ms     1 ms     2 ms  LAPTOP-IB6K1IJD [192.168.137.1]
  2     *        *        *     Délai d’attente de la demande dépassé.
  3     5 ms     6 ms     5 ms  10.33.3.253
  4     *        *        *     Délai d’attente de la demande dépassé.
  5
```

## 5. Petit chat privé

```
PS C:\Users\Quent\Desktop\netcat-1.11> .\nc.exe                                                                         Cmd line: -l -p 8888

PS C:\Users\adrik\Desktop\netcat-1.11> ./nc.exe
Cmd line: 192.168.137.1 8888

alo
chiky briky
anu cheeki briki
```
## Pour aller plus loin
```
PS C:\Users\Quent\Desktop\netcat-1.11> .\nc.exe                                                                         Cmd line: -l -p 9999 192.168.137.4

PS C:\Users\adrik\Desktop\netcat-1.11> ./nc.exe
Cmd line: 192.168.137.1 9999

pute
hello
pardon je pensais être seul
mince
ElPlatypus left the chat.
```
## 6. Wireshark

-Ping du client vers hote sur wireshark:

![](https://i.imgur.com/ccQtbb1.png)

-Envoi de message avec netcat:

![](https://i.imgur.com/wVSrSrB.png)

-Machine client qui se sert de la machine hote comme gateway:

![](https://i.imgur.com/obeg5WK.png)

## 7.Firewall

Dans Règles de trafic entrant, j'ai créé la règle ping_authorize qui authorise tous les trafics ICMP entrants.

Voilà mon ping :

```
PS C:\Users\adrik> ping 192.168.137.1

Envoi d’une requête 'Ping'  192.168.137.1 avec 32 octets de données :
Réponse de 192.168.137.1 : octets=32 temps=1 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=1 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=2 ms TTL=128
Réponse de 192.168.137.1 : octets=32 temps=2 ms TTL=128

Statistiques Ping pour 192.168.137.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 2ms, Moyenne = 1ms
```

Et le ping de Quentin : 

```
PS C:\Users\Quent\Desktop\netcat-1.11> ping 192.168.137.4
Envoi d’une requête 'Ping'  192.168.137.4 avec 32 octets de données :
Réponse de 192.168.137.4 : octets=32 temps=1 ms TTL=128
Réponse de 192.168.137.4 : octets=32 temps=2 ms TTL=128
Réponse de 192.168.137.4 : octets=32 temps=2 ms TTL=128
Réponse de 192.168.137.4 : octets=32 temps=2 ms TTL=128

Statistiques Ping pour 192.168.137.4:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 1ms, Maximum = 2ms, Moyenne = 1ms
```

Quentin a ouvert le port 8888 :

![](https://i.imgur.com/wPVP8kq.png)

```
PS C:\Users\adrik> .\Desktop\netcat-1.11\nc.exe
Cmd line: 192.168.137.1 8888
da
da
hg
```

# III. Manipulations d'autres outils/protocoles côté client

## 1. DHCP

On cherche le DHCP :

PS C:\Users\adrik> ipconfig /all
```
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : auvence.co
   Description. . . . . . . . . . . . . . : Realtek RTL8822BE 802.11ac PCIe Adapter
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%19(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.1.36(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : jeudi 23 janvier 2020 17:14:57
   Bail expirant. . . . . . . . . . . . . : jeudi 23 janvier 2020 18:14:57  <--- bail expirant
   Passerelle par défaut. . . . . . . . . : 10.33.3.253
   Serveur DHCP . . . . . . . . . . . . . : 10.33.3.254  <--- serveur DHCP
   IAID DHCPv6 . . . . . . . . . . . : 151820006
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : 10.33.10.148
                                       10.33.10.149
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```
On déconnecte les cartes :

```
PS C:\Users\adrik> ipconfig /release

Aucune opération ne peut être effectuée sur Connexion au réseau local* 1 lorsque
son média est déconnecté.
Aucune opération ne peut être effectuée sur Connexion au réseau local* 10 lorsque
son média est déconnecté.
Aucune opération ne peut être effectuée sur Connexion réseau Bluetooth lorsque
son média est déconnecté.

Carte Ethernet Ethernet :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :

Carte réseau sans fil Connexion au réseau local* 1 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :

Carte réseau sans fil Connexion au réseau local* 10 :

   Statut du média. . . . . . . . . . . . : Média déconnecté
   Suffixe DNS propre à la connexion. . . :
```

On les reconnecte pour récupérer une IP :

```
PS C:\Users\adrik> ipconfig /release

Aucune opération ne peut être effectuée sur Ethernet lorsque
son média est déconnecté.
Aucune opération ne peut être effectuée sur Connexion au réseau local* 1 lorsque
son média est déconnecté.
Aucune opération ne peut être effectuée sur Connexion au réseau local* 10 lorsque
son média est déconnecté.
Aucune opération ne peut être effectuée sur Connexion réseau Bluetooth lorsque
son média est déconnecté.

Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : auvence.co
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%19
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.1.36
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Passerelle par défaut. . . . . . . . . : 10.33.3.253
```

On peut voir que le bail à changé :

```
PS C:\Users\adrik> ipconfig /all

Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : auvence.co
   Description. . . . . . . . . . . . . . : Realtek RTL8822BE 802.11ac PCIe Adapter
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%19(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.1.36(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.252.0
   Bail obtenu. . . . . . . . . . . . . . : jeudi 23 janvier 2020 17:20:16
   Bail expirant. . . . . . . . . . . . . : jeudi 23 janvier 2020 18:20:15
   Passerelle par défaut. . . . . . . . . : 10.33.3.253
   Serveur DHCP . . . . . . . . . . . . . : 10.33.3.254
   IAID DHCPv6 . . . . . . . . . . . : 151820006
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : 10.33.10.148
                                       10.33.10.149
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```

## 2. DNS

PS C:\Users\adrik> ipconfig /all
```
Carte réseau sans fil Wi-Fi :

   Suffixe DNS propre à la connexion. . . : lan
   Description. . . . . . . . . . . . . . : Realtek RTL8822BE 802.11ac PCIe Adapter
   Adresse physique . . . . . . . . . . . : 0C-96-E6-AC-ED-57
   DHCP activé. . . . . . . . . . . . . . : Oui
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::9d49:b2a7:936b:b3df%19(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 192.168.1.13(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Bail obtenu. . . . . . . . . . . . . . : lundi 27 janvier 2020 10:21:25
   Bail expirant. . . . . . . . . . . . . : mardi 28 janvier 2020 10:23:24
   Passerelle par défaut. . . . . . . . . : 192.168.1.254
   Serveur DHCP . . . . . . . . . . . . . : 192.168.1.254
   IAID DHCPv6 . . . . . . . . . . . : 151820006
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : 192.168.1.254  <--- serveur DNS
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```



Nslookup :
```
PS C:\Users\adrik> nslookup google.com
Serveur :   bbox.lan
Address:  192.168.1.254

Réponse ne faisant pas autorité :
Nom :    google.com
Addresses:  2a00:1450:4007:810::200e
          216.58.213.142
```

```
PS C:\Users\adrik> nslookup ynov.com
Serveur :   bbox.lan
Address:  192.168.1.254

Réponse ne faisant pas autorité :
Nom :    ynov.com
Address:  217.70.184.38
```

On peut voir que le site de google que connaît le DNS a pour IP 216.58.213.142 et pour Ynov c'est l'IP 217.70.184.38


Reverse lookup :
```
PS C:\Users\adrik> nslookup 78.74.21.21
Serveur :   bbox.lan
Address:  192.168.1.254

Nom :    host-78-74-21-21.homerun.telia.com
Address:  78.74.21.21
```
```
PS C:\Users\adrik> nslookup 92.146.54.88
Serveur :   bbox.lan
Address:  192.168.1.254

Nom :    apoitiers-654-1-167-88.w92-146.abo.wanadoo.fr
Address:  92.146.54.88
```

On peut voir le nom des sites pour ces IP, soit telia.com et abo.wanadoo.fr
On voit également ce qui semble être l'endroit où sont hébergés les sites (host et apoitiers).