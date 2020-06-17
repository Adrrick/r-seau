# TP 3 - Routage, ARP, Spéléologie réseau

# Préparation de l'environnement

Allez amuse toi, du gros gameplay en prévision.

## client1.net1.tp3

```bash=
[user@client1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e2:3f:07 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d4:1f:99 brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.11/24 brd 10.3.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fed4:1f99/64 scope link
       valid_lft forever preferred_lft forever
[user@client1 ~]$
```

```bash=
[user@client1 ~]$ ss -ltn
State      Recv-Q Send-Q               Local Address:Port                              Peer Address:Port
LISTEN     0      128                              *:7777                                         *:*
LISTEN     0      128                           [::]:7777                                      [::]:*
```

```bash=
[user@client1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8
  sources:
  services: dhcpv6-client ssh
  ports: 7777/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

```bash=
[user@client1 ~]$ hostname
client1.net1.tp3
```

```bash=
[user@client1 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.3.1.254  router.tp3
10.3.2.11   server1.net2.tp3
```

```bash=
[user@client1 ~]$ ping router.tp3
PING router.tp3 (10.3.1.254) 56(84) bytes of data.
64 bytes from router.tp3 (10.3.1.254): icmp_seq=1 ttl=64 time=0.350 ms
64 bytes from router.tp3 (10.3.1.254): icmp_seq=2 ttl=64 time=0.347 ms
64 bytes from router.tp3 (10.3.1.254): icmp_seq=3 ttl=64 time=0.349 ms
^C
--- router.tp3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 0.347/0.348/0.350/0.021 ms
```

## server1.net2.tp3

```bash=
[user@server1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:cc:42:7e brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:19:5c:0a brd ff:ff:ff:ff:ff:ff
    inet 10.3.2.11/24 brd 10.3.2.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe19:5c0a/64 scope link
       valid_lft forever preferred_lft forever
```

```bash=
[user@server1 ~]$ ss -ltn
State      Recv-Q Send-Q               Local Address:Port                              Peer Address:Port
LISTEN     0      128                              *:7777                                         *:*
LISTEN     0      128                           [::]:7777                                      [::]:*
```

```bash=
[user@server1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8
  sources:
  services: dhcpv6-client ssh
  ports: 7777/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

```bash=
[user@server1 ~]$ hostname
server1.net2.tp3
```

```bash=
[user@server1 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.3.1.11   client1.net1.tp3
10.3.2.254  router.tp3
```

```bash=
[user@server1 ~]$ ping router.tp3
PING router.tp3 (10.3.2.254) 56(84) bytes of data.
64 bytes from router.tp3 (10.3.2.254): icmp_seq=1 ttl=64 time=0.585 ms
64 bytes from router.tp3 (10.3.2.254): icmp_seq=2 ttl=64 time=0.350 ms
64 bytes from router.tp3 (10.3.2.254): icmp_seq=3 ttl=64 time=0.327 ms
^C
--- router.tp3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.327/0.420/0.585/0.118 ms
```

## router.tp3

```bash=
[user@router ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:0a:c1:e4 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:31:ca:96 brd ff:ff:ff:ff:ff:ff
    inet 10.3.1.254/24 brd 10.3.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe31:ca96/64 scope link
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:cc:c7:76 brd ff:ff:ff:ff:ff:ff
    inet 10.3.2.254/24 brd 10.3.2.255 scope global noprefixroute enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fecc:c776/64 scope link
       valid_lft forever preferred_lft forever
```

```bash=
[user@router ~]$ ss -ltn
State      Recv-Q Send-Q               Local Address:Port                              Peer Address:Port
LISTEN     0      128                              *:7777                                         *:*
LISTEN     0      128                           [::]:7777                                      [::]:*
```

```bash=
[user@router ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s8 enp0s9
  sources:
  services: dhcpv6-client ssh
  ports: 7777/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

```bash=
[user@router ~]$ hostname
router.tp3
```

```bash=
[user@router ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.3.1.11   client1.net1.tp3
10.3.2.11   server1.net2.tp3
```

```bash=
[user@router ~]$ ping client1.net1.tp3
PING client1.net1.tp3 (10.3.1.11) 56(84) bytes of data.
64 bytes from client1.net1.tp3 (10.3.1.11): icmp_seq=1 ttl=64 time=0.279 ms
64 bytes from client1.net1.tp3 (10.3.1.11): icmp_seq=2 ttl=64 time=0.359 ms
64 bytes from client1.net1.tp3 (10.3.1.11): icmp_seq=3 ttl=64 time=0.341 ms
^C
--- client1.net1.tp3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.279/0.326/0.359/0.037 ms



[user@router ~]$ ping server1.net2.tp3
PING server1.net2.tp3 (10.3.2.11) 56(84) bytes of data.
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=1 ttl=64 time=0.346 ms
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=2 ttl=64 time=0.365 ms
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=3 ttl=64 time=0.350 ms
^C
--- server1.net2.tp3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.346/0.353/0.365/0.023 ms
```

# I. Mise en place du routage

## 1. Configuration du routage

```
[user@router ~]$ sudo sysctl -w net.ipv4.conf.all.forwarding=1
[sudo] password for user:
net.ipv4.conf.all.forwarding = 1
```

## 2. Ajouter les routes statiques

Côté client :

```
[user@client1 ~]$ ip r s
10.3.1.0/24 dev enp0s8 proto kernel scope link src 10.3.1.11 metric 101
10.3.2.0/24 via 10.3.2.254 dev enp0s8 proto static metric 101
10.3.2.254 dev enp0s8 proto static scope link metric 101
```

Côté serveur :

```
[user@server1 ~]$ ip r s
10.3.1.0/24 via 10.3.1.254 dev enp0s8 proto static metric 101
10.3.1.254 dev enp0s8 proto static scope link metric 101
10.3.2.0/24 dev enp0s8 proto kernel scope link src 10.3.2.11 metric 101
```

On vérifie avec un ping et traceroute :

```
[user@client1 ~]$ ping server1.net2.tp3
PING server1.net2.tp3 (10.3.2.11) 56(84) bytes of data.
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=1 ttl=63 time=0.578 ms
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=2 ttl=63 time=0.648 ms
64 bytes from server1.net2.tp3 (10.3.2.11): icmp_seq=3 ttl=63 time=0.653 ms
^C
--- server1.net2.tp3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.578/0.626/0.653/0.039 ms
```

```bash=
[user@client1]$ traceroute server1.net2.tp3
traceroute to server1.net2.tp3 (10.3.2.11), 30 hops max, 60 byte packets
 1  router.tp3 (10.3.1.254)  0.241 ms  0.146 ms  0.162 ms
 2  router.tp3 (10.3.1.254)  0.146 ms !X  0.163 ms !X  0.129 ms !X
```

## 3. Les trames sa mère

|             | MAC src       | MAC dst       | IP src       | IP dst       |
| ----------- | ------------- | ------------- | ------------ | ------------ |
| Dans `net1` (trame qui entre dans `router`) | 08:00:27:d4:1f:99 | 08:00:27:31:ca:96 | 10.3.1.11 | 10.3.2.11 |
| Dans `net2` (trame qui sort de `router`) | 08:00:27:cc:c7:76 | 08:00:27:19:5c:0a | 10.3.1.11 | 10.3.2.11 |

# II. ARP

## 1. Tables ARP

Table ARP client :

```bash=
[user@client1 ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:09 DELAY
10.3.1.254 dev enp0s8 lladdr 08:00:27:31:ca:96 STALE
10.3.2.254 dev enp0s8 lladdr 08:00:27:31:ca:96 STALE
```
- enp0s8 vers host-only net 1
- enp0s8 vers le routeur côté net1 (stale parce que le ping est passé depuis un petit moment)
- enp0s8 vers le routeur côté net2 (stale parce que le ping est passé depuis un petit moment)

Table ARP serveur :

```bash=
[user@server1 ~]$ ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:cc:c7:76 STALE
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:15 DELAY
10.3.2.254 dev enp0s8 lladdr 08:00:27:cc:c7:76 STALE
```

- enp0s8 vers le routeur côté net1 (stale parce que le ping est passé depuis un petit moment)
- enp0s8 vers host-only net 2
- enp0s8 vers le routeur côté net2 (stale parce que le ping est passé depuis un petit moment)

Table ARP router :

```bash=
[user@router ~]$ ip neigh show
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:15 DELAY
10.3.2.11 dev enp0s9 lladdr 08:00:27:19:5c:0a STALE
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:09 DELAY
10.3.1.11 dev enp0s8 lladdr 08:00:27:d4:1f:99 STALE
```
- enp0s8 vers host-only net 2
- enp0s9 vers serveur côté net 2
- enp0s8 vers host-only net 1
- enp0s8 vers client côté net 1

## 2. Requêtes ARPs

## Table ARP 1 :

- après flush :

```bash=
[user@client1 ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:09 REACHABLE
```

- après ping :

```bash=
[user@client1 ~]$ ip neigh show
10.3.1.1 dev enp0s8 lladdr 0a:00:27:00:00:09 REACHABLE
10.3.1.254 dev enp0s8 lladdr 08:00:27:31:ca:96 STALE
10.3.2.254 dev enp0s8 lladdr 08:00:27:31:ca:96 REACHABLE
```

## Table ARP 2 :

-après flush :

```bash=
[user@server1 ~]$ ip neigh show
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:15 REACHABLE
```

- après ping :

```bash=
[user@server1 ~]$ ip neigh show
10.3.1.254 dev enp0s8 lladdr 08:00:27:cc:c7:76 REACHABLE
10.3.2.1 dev enp0s8 lladdr 0a:00:27:00:00:15 DELAY
10.3.2.254 dev enp0s8 lladdr 08:00:27:cc:c7:76 REACHABLE
```

## Tcpdump 1 :

```bash=
1	0.000000	PcsCompu_d4:1f:99	Broadcast	ARP	42	Who has 10.3.2.254? Tell 10.3.1.11
2	0.000278	PcsCompu_31:ca:96	PcsCompu_d4:1f:99	ARP	60	10.3.2.254 is at 08:00:27:31:ca:96
13	5.016418	PcsCompu_31:ca:96	PcsCompu_d4:1f:99	ARP	60	Who has 10.3.1.11? Tell 10.3.1.254
14	5.017485	PcsCompu_d4:1f:99	PcsCompu_31:ca:96	ARP	42	10.3.1.11 is at 08:00:27:d4:1f:99
```

- Le client envoie une requête broadcast pour savoir qui est le routeur, il veut savoir quelle est son interface côté net2
- Le routeur lui envoie sa mac
- Le routeur envoie une requête pour savoir qui est le client côté net1
- le client lui envoie sa mac

## Tcpdump 2 :

```bash=
1	0.000000	PcsCompu_cc:c7:76	Broadcast	ARP	60	Who has 10.3.2.11? Tell 10.3.2.254
2	0.000018	PcsCompu_19:5c:0a	PcsCompu_cc:c7:76	ARP	42	10.3.2.11 is at 08:00:27:19:5c:0a
4	0.000285	PcsCompu_19:5c:0a	Broadcast	ARP	42	Who has 10.3.1.254? Tell 10.3.2.11
5	0.000546	PcsCompu_cc:c7:76	PcsCompu_19:5c:0a	ARP	60	10.3.1.254 is at 08:00:27:cc:c7:76
```

- Le routeur envoie une requête broadcast pour savoir qui est le serveur
- Le serveur lui envoie sa mac
- Le serveur envoie une requête broadcast pour savoir qui est le routeur, il veut savoir quelle est son interface côté net1
- Le routeur lui envoie sa mac

## U okay bro ?

- Le client envoie une requête broadcast pour savoir qui est le routeur, il veut savoir quelle est son interface côté net2
- Le routeur lui envoie sa mac
- Le routeur envoie une requête broadcast pour savoir qui est le serveur
- Le serveur lui envoie sa mac
- Le serveur envoie une requête broadcast pour savoir qui est le routeur, il veut savoir quelle est son interface côté net1
- Le routeur lui envoie sa mac
- Le routeur envoie une requête pour savoir qui est le client côté net1
- le client lui envoie sa mac

# Entracte

```
[user@router ~]$ ip a
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:0a:c1:e4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::292d:b18c:ce85:7cac/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

```
[user@router ~]$ sudo firewall-cmd --add-masquerade --permanent
[sudo] password for user:
success
[user@router ~]$ sudo firewall-cmd --reload
success
```

Mon enp0s3 sur le routeur voulait pas marcher, donc je saute ce passage.

# III. Plus de tcpdump

Bon je sais pas ce qui s'est passé mais :
- NAT de mon routeur qui est dead, impossible de la faire fonctionner (restart network, reboot, ONBOOT=yes, etc...) rien ne marche.  
- nc qui est encore buggé et qui s'installe pas (man vide) sur le client et le serveur, un peu comme Quentin pour le TP2 sauf qu'on était présent physiquement pour corriger le problème.  
Si c'était pas suffisant, ma NAT pour TOUTES mes VM s'est mise a déconner, pas possible de l'activer et dl nc pour client et serveur.

Donc bah toute la partie 3 est la partie de Quentin que j'ai suivi en stream Discord pour voir ce qu'il fallait faire. C'était pas si dur, j'ai le démon.  
Ca me gave de pas avoir pu la faire, mais bon au moins j'ai compris. A toi de voir comment tu note.

## 1. TCP et UDP

## B. Analyse de trames

## TCP

Par default la connexion de netcat est en TCP.

3-way handshake TCP:

```bash=
1	0.000000	10.3.2.254	10.3.2.11	TCP	74	45516 → 9999 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=3022462 TSecr=0 WS=128
2	0.000348	10.3.2.11	10.3.2.254	TCP	74	9999 → 45516 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=13147561 TSecr=3022462 WS=128
3	0.000622	10.3.2.254	10.3.2.11	TCP	66	45516 → 9999 [ACK] Seq=1 Ack=1 Win=29312 Len=0 TSval=3022463 TSecr=13147561
```

les ligne PSH, ACK sont les lignes de dialogue ou du texte est transmis:
```bash=
4	3.271984	10.3.2.254	10.3.2.11	TCP	72	45516 → 9999 [PSH, ACK] Seq=1 Ack=1 Win=29312 Len=6 TSval=3025734 TSecr=13147561
```


la fin de connexion est effectué par les deux cotés:
```bash=
14	18.827797	10.3.2.254	10.3.2.11	TCP	66	45516 → 9999 [FIN, ACK] Seq=10 Ack=14 Win=29312 Len=0 TSval=3041290 TSecr=13164297
15	18.828135	10.3.2.11	10.3.2.254	TCP	66	9999 → 45516 [FIN, ACK] Seq=14 Ack=11 Win=29056 Len=0 TSval=13166389 TSecr=3041290
```
##### UDP

Pour une connexion en UDP on rajoute -u a la commande.

Il y a une difference car le 3 way handshaked est remplacé par les SSDP:
```bash=
33	303.277043	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
34	304.279445	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
35	305.281068	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
36	306.281682	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
```

les ligne PSH, ACK sont remplacés par les simples ligne UDP qui transmettent le texte:
```bash=
37	392.476664	10.3.2.254	10.3.2.11	UDP	52	54868 → 9999 Len=10
40	403.866853	10.3.2.11	10.3.2.254	UDP	60	9999 → 54868 Len=12
```

la fin de connexion est en quatre etapes au lieu de deux:

```bash=
45	423.277325	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
46	424.278779	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1
47	425.279448	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
48	426.280202	10.3.2.1	239.255.255.250	SSDP	216	M-SEARCH * HTTP/1.1 
```
#### SSH

Après capture avec tcpdump on peut voir que la connexion en ssh est avec le protocole TCP:

```bash=
170	26.407331	10.3.1.11	10.3.2.11	TCP	74	47492 → 7777 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=5701124 TSecr=0 WS=128
171	26.408120	10.3.2.11	10.3.1.11	TCP	74	7777 → 47492 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=15826224 TSecr=5701124 WS=128
```