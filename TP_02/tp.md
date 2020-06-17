# TP 2 - Machine virtuelle, réseau, serveurs, routage simple

# I. Création et utilisation simples d'une VM CentOS

## 4. Configuration réseau d'une machine CentOS


| Name   | IP        | MAC                       | Fonction                    |
| ------ | --------- | ------------------------- | --------------------------- |
| enp0s3 | 10.0.2.15 | fe80::292d:b18c:ce85:7cac | carte NAT                   |
| enp0s8 | 10.2.1.3  | fe80::a00:27ff:fe4d:f1ed  | carte Wifi                  |

J'ai modifié enp0s8 en changeant l'ip de 1.

```
[user@patron ~]$ ip a

3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:53:25:f7 brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.4/24 brd 10.2.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe53:25f7/64 scope link
       valid_lft forever preferred_lft forever
```

Un petit ping :

```
PS C:\Users\adrik> ping 10.2.1.4

Envoi d’une requête 'Ping'  10.2.1.4 avec 32 octets de données :
Réponse de 10.2.1.4 : octets=32 temps<1ms TTL=64
Réponse de 10.2.1.4 : octets=32 temps<1ms TTL=64
Réponse de 10.2.1.4 : octets=32 temps<1ms TTL=64
Réponse de 10.2.1.4 : octets=32 temps<1ms TTL=64

Statistiques Ping pour 10.2.1.4:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
```

## 5. Apréhension de quelques commandes

* **Nmap**

J'ai fait un nmap du réseau host-only :

```
[user@patron ~]$ nmap -v -A 10.2.1.0/24

Starting Nmap 6.40 ( http://nmap.org ) at 2020-02-13 16:44 CET
NSE: Loaded 110 scripts for scanning.
NSE: Script Pre-scanning.
Initiating Ping Scan at 16:44
Scanning 256 hosts [2 ports/host]
Completed Ping Scan at 16:44, 3.01s elapsed (256 total hosts)
Initiating Parallel DNS resolution of 256 hosts. at 16:44
Completed Parallel DNS resolution of 256 hosts. at 16:44, 0.01s elapsed

[...]

Host script results:
| nbstat:
|   NetBIOS name: LAPTOP-31O3RQGM, NetBIOS user: <unknown>, NetBIOS MAC: 0a:00:27:00:00:09 (unknown)
|   Names
|     LAPTOP-31O3RQGM<00>  Flags: <unique><active>
|     WORKGROUP<00>        Flags: <group><active>
|_    LAPTOP-31O3RQGM<20>  Flags: <unique><active>
|_smbv2-enabled: Server supports SMBv2 protocol

Nmap scan report for 10.2.1.4
Host is up (0.00015s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey: 2048 ee:43:9d:4f:75:b7:d4:b3:43:81:35:4e:60:e8:36:9e (RSA)
|_256 6f:55:1d:43:08:ac:19:9f:68:55:93:05:9e:a6:1c:37 (ECDSA)

NSE: Script Post-scanning.
Initiating NSE at 16:44
Completed NSE at 16:44, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
Nmap done: 256 IP addresses (2 hosts up) scanned in 16.30 seconds
```

On peut voir que nmap a détecté ma carte host-only de VirtualBox (LAPTOP-3103RGQM).

```
PS C:\Users\adrik> ipconfig /all

Carte Ethernet VirtualBox Host-Only Network :

   Suffixe DNS propre à la connexion. . . :
   Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter
   Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-09
   DHCP activé. . . . . . . . . . . . . . : Non
   Configuration automatique activée. . . : Oui
   Adresse IPv6 de liaison locale. . . . .: fe80::4908:39de:a1dd:4552%9(préféré)
   Adresse IPv4. . . . . . . . . . . . . .: 10.2.1.1(préféré)
   Masque de sous-réseau. . . . . . . . . : 255.255.255.0
   Passerelle par défaut. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 1007288359
   DUID de client DHCPv6. . . . . . . . : 00-01-00-01-23-CE-04-50-B0-0C-D1-51-44-46
   Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBIOS sur Tcpip. . . . . . . . . . . : Activé
```

* **ss**

```
[user@patron ~]$ ss -l -t -u

Netid  State      Recv-Q Send-Q          Local Address:Port                           Peer Address:Port
udp    UNCONN     0      0                           *:bootpc                                    *:*
tcp    LISTEN     0      100                 127.0.0.1:smtp                                      *:*
tcp    LISTEN     0      128                         *:ssh                                       *:*
tcp    LISTEN     0      100                     [::1]:smtp                                   [::]:*
tcp    LISTEN     0      128                      [::]:ssh                                    [::]:*
```

# II. Notion de ports

## 1. SSH

```
[user@patron ~]$ sudo ss -ltpun

Netid  State      Recv-Q Send-Q            Local Address:Port                           Peer Address:Port
tcp    LISTEN     0      128                           *:22                                        *:*                   users:(("sshd",pid=1085,fd=3))
```

On se connecte en SSH :

```
PS C:\Users\adrik> ssh user@10.2.1.4

user@10.2.1.4's password:
Last login: Thu Feb 13 16:50:07 2020 from 10.2.1.1
[user@patron ~]$
```

On met en évidence la connexion :

```
[user@patron ~]$ ss -l -u
State      Recv-Q Send-Q             Local Address:Port                              Peer Address:Port
UNCONN     0      0                              *:bootpc                                       *:*
```

## 2. Firewall

**SSH**

Je suis allé modifier la valeur du port dans sshd_config :

```
# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
Port 33000
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

Une petite vérification après avoir relancé ssh :

```
[user@patron ~]$ sudo ss -ltpu

Netid  State      Recv-Q Send-Q                 Local Address:Port                                  Peer Address:Port
udp    UNCONN     0      0                                  *:bootpc                                           *:*                     users:(("dhclient",pid=863,fd=6))
tcp    LISTEN     0      100                        127.0.0.1:smtp                                             *:*                     users:(("master",pid=1349,fd=13))
tcp    LISTEN     0      128                                *:33000                                            *:*                     users:(("sshd",pid=1477,fd=3))
tcp    LISTEN     0      100                            [::1]:smtp                                          [::]:*                     users:(("master",pid=1349,fd=14))
tcp    LISTEN     0      128                             [::]:33000                                         [::]:*                     users:(("sshd",pid=1477,fd=4))
```

On peut voir que le port ssh est bien devenu 33000.

On teste la co :

```
PS C:\Users\adrik> nmap -p 33000 10.2.1.4

Starting Nmap 7.80 ( https://nmap.org ) at 2020-02-20 11:04 Paris, Madrid
Nmap scan report for 10.2.1.4
Host is up (0.00s latency).

PORT      STATE    SERVICE
33000/tcp filtered unknown
MAC Address: 08:00:27:53:25:F7 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 2.22 seconds
```

Nmap indique que le port est filtered, ce qui veut dire que Nmap est bloqué par le firewall.
On modifie la règle avec sudo firewall-cmd --add-port=33000/tcp --permanent, et on reload.

On refait un Nmap sur 33000 :

```
PS C:\Users\adrik> nmap -p 33000 10.2.1.4

Starting Nmap 7.80 ( https://nmap.org ) at 2020-02-20 11:16 Paris, Madrid
Nmap scan report for 10.2.1.4
Host is up (0.00s latency).

PORT      STATE SERVICE
33000/tcp open  unknown
MAC Address: 08:00:27:53:25:F7 (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 1.53 seconds
```

Le port 33000 est bien ouvert.

**Netcat**

J'ai lancé 3 Powershells : 2 en SSH sur la VM, un pour mon PC hôte. J'ai utilisé le port 55000.

Dans le premier connecté en SSH j'ai lancé le serveur :

```
[user@patron ~]$ nc -l 55000

```

Ensuite j'ai essayé de me connecter avec mon PC hôte sur le serveur :

```
PS C:\Users\adrik\Desktop\ynov\netcat-1.11> .\nc64

Cmd line: 10.2.1.4 55000
salut
```

On peut voir que le message est arrivé sur la VM :

```
[user@patron ~]$ nc -l 55000
salut
```

Avec le troisième terminal, j'ai fait un ss :

```
[user@patron ~]$ ss -t

State      Recv-Q Send-Q             Local Address:Port                              Peer Address:Port
ESTAB      0      0                       10.2.1.4:ssh                                   10.2.1.1:59978
ESTAB      0      36                      10.2.1.4:ssh                                   10.2.1.1:59976
ESTAB      0      0                       10.2.1.4:55000                                 10.2.1.1:60000
```

On peut voir la connexion.


Dans le sens inverse :

```
PS C:\Users\adrik\Desktop\ynov\netcat-1.11> .\nc64.exe -l -u -p 55000

```

```
[user@patron ~]$ nc -u 10.2.1.1 55000
salut
```

```
PS C:\Users\adrik\Desktop\ynov\netcat-1.11> .\nc64.exe -l -u -p 55000
salut
```

```
PS C:\Users\adrik> netstat -a -p UDP

Connexions actives

  Proto  Adresse locale         Adresse distante       État
  [...]
  UDP    0.0.0.0:55000          *:*
```

**Wireshark**

J'ai envoyé wololo sur le serveur netcat.

Voici ce qu'il se passe sur Wireshark quand le serveur est sur l'hôte :

![](https://i.imgur.com/oybx56x.png)

Et quand le serveur est sur la VM :

![](https://i.imgur.com/vU2ZdSp.png)


# III. Routage statique

Cette partie a été réalisée avec Hugo et Quentin.

## 2. Configuration du routage

**PC1**

J'ai ajouté la route pour atteindre Hugo, et je l'ai ping.

```
PS C:\windows\system32> route add 10.2.3.0/24 mask 255.255.255.0 10.2.12.3
 OK!

PS C:\windows\system32> ping 10.2.3.2

Envoi d’une requête 'Ping'  10.2.3.2 avec 32 octets de données :
Réponse de 10.2.3.2 : octets=32 temps=2 ms TTL=127
Réponse de 10.2.3.2 : octets=32 temps=2 ms TTL=127
Réponse de 10.2.3.2 : octets=32 temps=2 ms TTL=127
Réponse de 10.2.3.2 : octets=32 temps=2 ms TTL=127

Statistiques Ping pour 10.2.3.2:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 2ms, Maximum = 2ms, Moyenne = 2ms
```

**PC2**

Il a fait de même.

```
PS C:\WINDOWS\system32> route add 10.2.1.0/24 mask 255.255.255.0 10.2.12.1
 OK!

PS C:\WINDOWS\system32> ping 10.2.1.1

Pinging 10.2.1.1 with 32 bytes of data:
Reply from 10.2.1.1: bytes=32 time=2ms TTL=127
Reply from 10.2.1.1: bytes=32 time=2ms TTL=127
Reply from 10.2.1.1: bytes=32 time=2ms TTL=127
Reply from 10.2.1.1: bytes=32 time=2ms TTL=127

Ping statistics for 10.2.1.1:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 2ms, Maximum = 2ms, Average = 2ms
```

**VM1**

Je ping Quentin via le réseau 2.

```
[user@patron ~]$ sudo ip route add 10.2.2.0/24 via 10.2.1.1 dev enp0s8

[user@patron ~]$ ping 10.2.2.1
PING 10.2.2.1 (10.2.2.1) 56(84) bytes of data.
^C
--- 10.2.2.1 ping statistics ---
7 packets transmitted, 0 received, 100% packet loss, time 6008ms
```

Un petit traceroute ?

```
[user@patron ~]$ traceroute 10.2.2.2

traceroute to 10.2.2.2 (10.2.2.2), 30 hops max, 60 byte packets
 1  10.2.1.1 (10.2.1.1)  0.191 ms * *
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
```

Et je ping directement la VM de Quentin.

```
[user@patron ~]$ ping 10.2.3.2

PING 10.2.3.2 (10.2.3.2) 56(84) bytes of data.
64 bytes from 10.2.3.2: icmp_seq=1 ttl=126 time=2.56 ms
64 bytes from 10.2.3.2: icmp_seq=2 ttl=126 time=1.94 ms
64 bytes from 10.2.3.2: icmp_seq=3 ttl=126 time=1.89 ms
^C
--- 10.2.3.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2014ms
rtt min/avg/max/mdev = 1.897/2.136/2.566/0.306 ms
[user@patron ~]$ ping 10.2.2.10
PING 10.2.2.10 (10.2.2.10) 56(84) bytes of data.
64 bytes from 10.2.2.10: icmp_seq=1 ttl=62 time=2.50 ms
64 bytes from 10.2.2.10: icmp_seq=2 ttl=62 time=2.51 ms
64 bytes from 10.2.2.10: icmp_seq=3 ttl=62 time=2.49 ms
^C
--- 10.2.2.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2016ms
rtt min/avg/max/mdev = 2.499/2.505/2.514/0.058 ms
```

Un autre petit traceroute ?

```
[user@patron network-scripts]$ traceroute 10.2.2.10

traceroute to 10.2.2.10 (10.2.2.10), 30 hops max, 60 byte packets
 1  10.2.1.1 (10.2.1.1)  0.311 ms * *
 2  * * *
 3  10.2.2.10 (10.2.2.10)  2.693 ms !X  2.681 ms !X  2.640 ms !X
```

**VM2**

Pareil mais du côté de Quentin.

```
[user@patron ~]$ sudo ip route add 10.2.1.0/24 via 10.2.2.2 dev enp0s8

[user@patron ~]$ ping 10.2.1.1

PING 10.2.1.1 (10.2.1.1) 56(84) bytes of data.
64 bytes from 10.2.1.1: icmp_seq=1 ttl=126 time=1.95 ms
64 bytes from 10.2.1.1: icmp_seq=2 ttl=126 time=2.18 ms
64 bytes from 10.2.1.1: icmp_seq=3 ttl=126 time=2.25 ms
64 bytes from 10.2.1.1: icmp_seq=4 ttl=126 time=2.23 ms
64 bytes from 10.2.1.1: icmp_seq=5 ttl=126 time=2.20 ms
64 bytes from 10.2.1.1: icmp_seq=6 ttl=126 time=1.96 ms
64 bytes from 10.2.1.1: icmp_seq=7 ttl=126 time=2.01 ms
^C
--- 10.2.1.1 ping statistics ---
7 packets transmitted, 7 received, 0% packet loss, time 6011ms
rtt min/avg/max/mdev = 1.956/2.115/2.251/0.130 ms
```

Son premier traceroute :

```
[user@patron ~]$ traceroute 10.2.1.1

traceroute to 10.2.1.1 (10.2.1.1), 30 hops max, 60 byte packets
 1  10.2.2.2 (10.2.2.2)  0.158 ms * *
```

Et son ping sur ma VM :

```
[user@patron ~]$ ping 10.2.1.10

PING 10.2.1.10 (10.2.1.10) 56(84) bytes of data.
64 bytes from 10.2.1.10: icmp_seq=1 ttl=62 time=2.28 ms
64 bytes from 10.2.1.10: icmp_seq=2 ttl=62 time=1.34 ms
^C
--- 10.2.1.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.341/1.815/2.289/0.474 ms
```

Puis son autre traceroute : 

```
[user@patron ~]$ traceroute 10.2.1.10

traceroute to 10.2.1.10 (10.2.1.10), 30 hops max, 60 byte packets
 1  10.2.2.2 (10.2.2.2)  0.309 ms * *
 2  * * *
 3  10.2.1.10 (10.2.1.10)  1.296 ms !X  1.191 ms !X  1.104 ms !X
```

## 3. Configuration des noms de domaine

Je ping Quentin (VM2) avec le nom de domaine.

```
[user@patron /]$ ping vm2.tp2.b1

PING vm2.tp2.b1 (10.2.2.10) 56(84) bytes of data.
64 bytes from vm2.tp2.b1 (10.2.2.10): icmp_seq=1 ttl=62 time=2.38 ms
64 bytes from vm2.tp2.b1 (10.2.2.10): icmp_seq=2 ttl=62 time=2.92 ms
64 bytes from vm2.tp2.b1 (10.2.2.10): icmp_seq=3 ttl=62 time=2.34 ms
^C
--- vm2.tp2.b1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 2.348/2.551/2.923/0.266 ms
```

Puis un traceroute.

```
[user@patron /]$ traceroute vm2.tp2.b1

traceroute to vm2.tp2.b1 (10.2.2.10), 30 hops max, 60 byte packets
 1  10.2.1.1 (10.2.1.1)  0.165 ms * *
 2  * * *
 3  vm2.tp2.b1 (10.2.2.10)  3.477 ms !X  3.396 ms !X  3.375 ms !X
```

Et enfin le netcat. (attention il est magique)

Côté host

```
[user@patron etc]$ nc -l 22000

!
OWO
et hop
salope
t'es une énorme salope
tu veux une blague ?
oui
non enfaite
a
tt les jours je plor
oscur
```

Côté client

```
[user@patron ~]$ nc vm2.tp2.b1 22000

!
OWO
et hop
t'es une salope
énorme salope
tu veux une blague ?
oui
non enfaite
a
tt les jours je plor
oscur
```
