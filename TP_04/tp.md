# TP 4 - Cisco, Routage, DHCP

## I. Topologie 1 : simple

### 2. Mise en place

#### B. Définition d'IPs statiques

admin 1 :  

Je te cache pas que comme je savais pas comment utiliser SSH quand on met une VM dans GNS3 j'ai grave la flemme de tout réécrire, donc voilà en résumé ce que j'ai fait :  
- sudo setenforce 0 avec SELINUX=permissive
- traceroute était déjà installé sur le patron
- IPADDR=10.4.1.11
- echo 'admin1' | sudo tee /etc/hostname

router 1 :  

```
R1#show ip int br

Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            10.4.1.254      YES manual up                    up  
FastEthernet1/0            10.4.2.254      YES manual up                    up
```

```
R1/clic droit/configure/name : router1
```

guest1 :  

```
guest1> ip 10.4.2.11
Checking for duplicate address...
PC1 : 10.4.2.11 255.255.255.0
```

```
VPCS/clic droit/configure/name : guest1
```

Vérification :  

```
guest1> ping 10.4.2.254

84 bytes from 10.4.2.254 icmp_seq=1 ttl=255 time=9.445 ms
84 bytes from 10.4.2.254 icmp_seq=2 ttl=255 time=8.845 ms
84 bytes from 10.4.2.254 icmp_seq=3 ttl=255 time=10.854 ms
84 bytes from 10.4.2.254 icmp_seq=4 ttl=255 time=3.760 ms
84 bytes from 10.4.2.254 icmp_seq=5 ttl=255 time=8.928 ms
^C
```

```
[user@admin1 ~]$ ping 10.4.1.254
PING 10.4.1.254 (10.4.1.254) 56(84) bytes of data.
64 bytes from 10.4.1.254: icmp_seq=1 ttl=255 time=1.77 ms
64 bytes from 10.4.1.254: icmp_seq=2 ttl=255 time=7.10 ms
64 bytes from 10.4.1.254: icmp_seq=3 ttl=255 time=6.20 ms
^C
```

```
router1#ping 10.4.1.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.1.11, timeout is 2 seconds:
.!!!!
Success rate is 80 percent (4/5), round-trip min/avg/max = 24/38/44 ms


router1#ping 10.4.2.11

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.4.2.11, timeout is 2 seconds:
.!!!!
Success rate is 80 percent (4/5), round-trip min/avg/max = 32/33/36 ms
```

```
router1#show arp

Protocol  Address          Age (min)  Hardware Addr   Type   Interface
Internet  10.4.1.11              31   0800.27a8.2812  ARPA   FastEthernet0/0
Internet  10.4.2.11              12   0050.7966.6800  ARPA   FastEthernet1/0
Internet  10.4.1.254              -   cc01.0448.0000  ARPA   FastEthernet0/0
Internet  10.4.2.254              -   cc01.0448.0010  ARPA   FastEthernet1/0
```

- admin1 : 

```
[user@admin1 ~]$ ip a

link/ether 08:00:27:a8:28:12 brd ff:ff:ff:ff:ff:ff
```

- guest1 : 

```
guest1> show ip

NAME        : guest1[1]
IP/MASK     : 10.4.2.11/24
GATEWAY     : 0.0.0.0
DNS         :
MAC         : 00:50:79:66:68:00
LPORT       : 20010
RHOST:PORT  : 127.0.0.1:20011
MTU:        : 1500
```

#### C. Définition d'IPs statiques

- admin1  :

```
10.4.2.0/24 via 10.4.2.254 dev enp0s8
```

- guest1 :

```
guest1> ip 10.4.2.11/24 10.4.2.254
Checking for duplicate address...
PC1 : 10.4.2.11 255.255.255.0 gateway 10.4.2.254

guest1> show ip

NAME        : guest1[1]
IP/MASK     : 10.4.2.11/24
GATEWAY     : 10.4.2.254
DNS         :
MAC         : 00:50:79:66:68:00
LPORT       : 20007
RHOST:PORT  : 127.0.0.1:20008
MTU:        : 1500
```

Vérification :  

```
guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=16.205 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=15.719 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=14.296 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=15.527 ms
^C
```

```
[user@admin1 ~]$ ping 10.4.2.11
PING 10.4.2.11 (10.4.2.11) 56(84) bytes of data.
64 bytes from 10.4.2.11: icmp_seq=1 ttl=63 time=3017 ms
64 bytes from 10.4.2.11: icmp_seq=2 ttl=63 time=2014 ms
64 bytes from 10.4.2.11: icmp_seq=3 ttl=63 time=1012 ms
^C
```

```
[user@admin1 ~]$ traceroute 10.4.2.11
traceroute to 10.4.2.11 (10.4.2.11), 30 hops max, 60 byte packets
 1  10.4.1.254 (10.4.1.254)  10.517 ms  10.396 ms  10.308 ms
 2  10.4.2.11 (10.4.2.11)  3022.439 ms * *

guest1> trace 10.4.1.11
trace to 10.4.1.11, 8 hops max, press Ctrl+C to stop
 1   10.4.2.254   5.421 ms  10.135 ms  10.205 ms
 2   *10.4.1.11   20.010 ms (ICMP type:3, code:10, Host administratively prohibited)
```

## II. Topologie 2 : dumb switches

#### C. Vérification

- guest1 :
```
guest1> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=31.360 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=11.121 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=14.715 ms
84 bytes from 10.4.1.11 icmp_seq=4 ttl=63 time=14.609 ms
^C
```

- admin1 :
```
[user@admin1 ~]$ ping 10.4.2.11
PING 10.4.2.11 (10.4.2.11) 56(84) bytes of data.
64 bytes from 10.4.2.11: icmp_seq=1 ttl=63 time=3007 ms
64 bytes from 10.4.2.11: icmp_seq=2 ttl=63 time=2007 ms
^C
```

- routes
```
[user@admin1 ~]$ traceroute 10.4.2.11
traceroute to 10.4.2.11 (10.4.2.11), 30 hops max, 60 byte packets
 1  10.4.1.254 (10.4.1.254)  5.621 ms  5.471 ms  5.364 ms
 2  10.4.2.11 (10.4.2.11)  3013.495 ms * *
```
```
guest1> trace 10.4.1.11
trace to 10.4.1.11, 8 hops max, press Ctrl+C to stop
 1   10.4.2.254   10.365 ms  10.136 ms  10.182 ms
 2   *10.4.1.11   20.299 ms (ICMP type:3, code:10, Host administratively prohibited)
```

## III. Topologie 3 : adding nodes and NAT

### B. VPCS

- guest2 :

```
guest2> ip 10.4.2.12/24 10.4.2.254
Checking for duplicate address...
PC1 : 10.4.2.12 255.255.255.0 gateway 10.4.2.254

guest2> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=20.063 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=15.787 ms
84 bytes from 10.4.1.11 icmp_seq=3 ttl=63 time=11.687 ms
^C
```

- guest3 :

```
guest3> ip 10.4.2.13/24 10.4.2.254
Checking for duplicate address...
PC1 : 10.4.2.13 255.255.255.0 gateway 10.4.2.254

guest3> ping 10.4.1.11
84 bytes from 10.4.1.11 icmp_seq=1 ttl=63 time=19.868 ms
84 bytes from 10.4.1.11 icmp_seq=2 ttl=63 time=13.782 ms
^C
```

### C. Accès WAN

- routeur :

```
R1#show ip int br
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            10.4.2.254      YES manual up                    up  
FastEthernet1/0            10.4.1.254      YES manual up                    up  
FastEthernet2/0            192.168.122.17  YES DHCP   up                    up  
NVI0                       unassigned      NO  unset  up                    up 
```

Config :  

```
guest1> ip dns 1.1.1.1

guest2> ip dns 1.1.1.1

guest3> ip dns 1.1.1.1
```

```
[user@admin1 ~]$ sudo ip route add default via 10.4.1.254 dev enp0s8
```


Vérification :  

```
R1#ping 8.8.8.8

Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 8.8.8.8, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 16/24/40 ms


guest1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=30.633 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=50 time=27.459 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=50 time=32.255 ms
^C
guest1> ping google.com
google.com resolved to 216.58.209.238
84 bytes from 216.58.209.238 icmp_seq=1 ttl=50 time=30.072 ms
84 bytes from 216.58.209.238 icmp_seq=2 ttl=50 time=23.060 ms
84 bytes from 216.58.209.238 icmp_seq=3 ttl=50 time=22.151 ms
^C


guest2> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=30.062 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=50 time=47.455 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=50 time=30.768 ms
^C
guest2> ping google.com
google.com resolved to 216.58.204.110
84 bytes from 216.58.204.110 icmp_seq=1 ttl=50 time=30.064 ms
84 bytes from 216.58.204.110 icmp_seq=2 ttl=50 time=24.031 ms
84 bytes from 216.58.204.110 icmp_seq=3 ttl=50 time=24.542 ms
^C


guest3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=31.207 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=50 time=31.562 ms
84 bytes from 8.8.8.8 icmp_seq=3 ttl=50 time=23.757 ms
^C
guest3> ping google.com
google.com resolved to 216.58.204.110
84 bytes from 216.58.204.110 icmp_seq=1 ttl=50 time=29.840 ms
84 bytes from 216.58.204.110 icmp_seq=2 ttl=50 time=30.596 ms
84 bytes from 216.58.204.110 icmp_seq=3 ttl=50 time=36.231 ms
^C


[user@admin1 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=50 time=36.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=50 time=25.0 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=50 time=25.8 ms
^C
[user@admin1 ~]$ ping google.com
PING google.com (172.217.18.206) 56(84) bytes of data.
64 bytes from par10s38-in-f14.1e100.net (172.217.18.206): icmp_seq=1 ttl=50 time=31.1 ms
64 bytes from par10s38-in-f14.1e100.net (172.217.18.206): icmp_seq=2 ttl=50 time=26.8 ms
64 bytes from par10s38-in-f14.1e100.net (172.217.18.206): icmp_seq=3 ttl=50 time=25.7 ms
```

## IV. Topologie 3 : adding nodes and NAT

### 2. Mise en place

J'ai vu que les ports utilisé par DHCP sont 67 et 68, j'ai donc regardé ce qui était ouvert sur ma VM.  

```
[user@dhcp ~]$ ss -tuln
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port
udp     UNCONN  0   0                *:67               *:*
```

J'ai essayé de mettre une ip en DHCP sur guest1, puis j'ai vérifié que j'ai Internet :  

```
guest1> ip dhcp
DDORA IP 10.4.2.101/24 GW 10.4.2.254

guest1> ping google.com
google.com resolved to 216.58.204.110
84 bytes from 216.58.204.110 icmp_seq=1 ttl=50 time=31.037 ms
84 bytes from 216.58.204.110 icmp_seq=2 ttl=50 time=27.376 ms
84 bytes from 216.58.204.110 icmp_seq=3 ttl=50 time=24.984 ms
^C
```

Et enfin, le DORA sur Wireshark :  

![](https://image.noelshack.com/fichiers/2020/14/2/1585671729-capture.png)
