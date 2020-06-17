# TP 5 - Une "vraie" topologie ?

## I. Topologie 1 - intro VLAN

### 2. Setup clients

Ping :  
```
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.370 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=0.589 ms
84 bytes from 10.5.10.12 icmp_seq=3 ttl=64 time=0.709 ms
^C
```

```
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.381 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=0.530 ms
84 bytes from 10.5.20.12 icmp_seq=3 ttl=64 time=0.602 ms
^C
```

### VLANs :  

Switch 1 :  
```
IOU1#show vlan

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/3, Et1/0, Et1/1, Et1/2
                                                Et1/3, Et2/0, Et2/1, Et2/2
                                                Et2/3, Et3/0, Et3/1, Et3/2
                                                Et3/3
10   admins                           active    Et0/1
20   guests                           active    Et0/2
1002 fddi-default                     act/unsup
1003 token-ring-default               act/unsup
1004 fddinet-default                  act/unsup
1005 trnet-default                    act/unsup
```

```
IOU1#show interface trunk

Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1

Port        Vlans allowed on trunk
Et0/0       1-4094

Port        Vlans allowed and active in management domain
Et0/0       1,10,20

Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       1,10,20
```

Switch 2 :  
```
IOU2#show vlan

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/3, Et1/0, Et1/1, Et1/2
                                                Et1/3, Et2/0, Et2/1, Et2/2
                                                Et2/3, Et3/0, Et3/1, Et3/2
                                                Et3/3
10   admins                           active    Et0/1
20   guests                           active    Et0/2
1002 fddi-default                     act/unsup
1003 token-ring-default               act/unsup
1004 fddinet-default                  act/unsup
1005 trnet-default                    act/unsup
```

```
IOU2#show interface trunk

Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1

Port        Vlans allowed on trunk
Et0/0       10,20

Port        Vlans allowed and active in management domain
Et0/0       10,20

Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       10,20
```


Vérifications :  
```
admin1> ping 10.5.10.12
84 bytes from 10.5.10.12 icmp_seq=1 ttl=64 time=0.517 ms
84 bytes from 10.5.10.12 icmp_seq=2 ttl=64 time=0.695 ms
84 bytes from 10.5.10.12 icmp_seq=3 ttl=64 time=0.543 ms
^C
```

```
guest1> ping 10.5.20.12
84 bytes from 10.5.20.12 icmp_seq=1 ttl=64 time=0.444 ms
84 bytes from 10.5.20.12 icmp_seq=2 ttl=64 time=0.600 ms
84 bytes from 10.5.20.12 icmp_seq=3 ttl=64 time=0.748 ms
^C
```

En changeant l'ip de guest1 :  
```
guest1>
guest1> ip 10.5.10.13/24
Checking for duplicate address...
PC1 : 10.5.10.13 255.255.255.0

guest1> ping 10.5.10.11
host (10.5.10.11) not reachable
```

## II. Topologie 2 - VLAN, sous-interface, NAT

### 2. Adressage

```
admin3> ping 10.5.10.11
84 bytes from 10.5.10.11 icmp_seq=1 ttl=64 time=0.517 ms
84 bytes from 10.5.10.11 icmp_seq=2 ttl=64 time=0.727 ms
84 bytes from 10.5.10.11 icmp_seq=3 ttl=64 time=0.775 ms
^C
```

```
guest3> ping 10.5.20.11
84 bytes from 10.5.20.11 icmp_seq=1 ttl=64 time=0.583 ms
84 bytes from 10.5.20.11 icmp_seq=2 ttl=64 time=0.605 ms
84 bytes from 10.5.20.11 icmp_seq=3 ttl=64 time=0.904 ms
^C
```

### 3. VLAN

Mise en place :  

```
IOU3#show vlan

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/0, Et0/3, Et1/0, Et1/1
                                                Et1/2, Et1/3, Et2/0, Et2/1
                                                Et2/2, Et2/3, Et3/0, Et3/1
                                                Et3/2, Et3/3
10   admins                           active    Et0/1
20   guests                           active    Et0/2
1002 fddi-default                     act/unsup
1003 token-ring-default               act/unsup
1004 fddinet-default                  act/unsup
1005 trnet-default                    act/unsup
```

```
IOU3#show interface trunk

Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1

Port        Vlans allowed on trunk
Et0/0       1-4094

Port        Vlans allowed and active in management domain
Et0/0       1,10,20

Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       1,10,20
```

On teste ?  

```
guest1> ip 10.5.10.14/24
Checking for duplicate address...
PC1 : 10.5.10.14 255.255.255.0

guest1> ping 10.5.10.13
host (10.5.10.13) not reachable
```

### 4. Sous interface

R1 :  

```
R1#show ip int br
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  up                    up  
FastEthernet0/0.10         10.5.10.254     YES manual up                    up  
FastEthernet0/0.20         10.5.20.254     YES manual up                    up  
FastEthernet1/0            unassigned      YES unset  administratively down down
```

On vérifie ?  

```
admin3> ping 10.5.10.254
84 bytes from 10.5.10.254 icmp_seq=1 ttl=255 time=9.411 ms
84 bytes from 10.5.10.254 icmp_seq=2 ttl=255 time=9.122 ms
84 bytes from 10.5.10.254 icmp_seq=3 ttl=255 time=7.613 ms
^C

guest3> ping 10.5.20.254
84 bytes from 10.5.20.254 icmp_seq=1 ttl=255 time=9.197 ms
84 bytes from 10.5.20.254 icmp_seq=2 ttl=255 time=9.412 ms
84 bytes from 10.5.20.254 icmp_seq=3 ttl=255 time=1.763 ms
^C
```

### 5. NAT

NAT sur R1 :  

```
R1#show ip int br
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  up                    up  
FastEthernet0/0.10         10.5.10.254     YES manual up                    up  
FastEthernet0/0.20         10.5.20.254     YES manual up                    up  
FastEthernet1/0            192.168.122.102 YES DHCP   up                    up  
NVI0                       unassigned      NO  unset  up                    up 
```

On teste ?  

```
admin1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=29.924 ms
^C

admin2> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=29.594 ms
^C

admin3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=40.154 ms
^C
```

```
guest1> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=29.455 ms
^C

guest2> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=30.047 ms
^C

guest3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=29.713 ms
^C
```

## III. Topologie 3 - Ajouter des services

### 3. Serveur DHCP

J'ai testé avec guest3 de récupérer une ip en DHCP :  

```
guest3> ip dhcp
DDORA IP 10.5.20.100/24 GW 10.5.20.254

guest3> ping 8.8.8.8
84 bytes from 8.8.8.8 icmp_seq=1 ttl=50 time=28.999 ms
84 bytes from 8.8.8.8 icmp_seq=2 ttl=50 time=24.008 ms
^C
```

### 4. Serveur Web

J'ai eu le même problème qu'au TP3, la VM voulait plus rien yum. Donc j'ai sauté.

### 5. Serveur DNS

Décidément j'ai pas de chance sur les fins de TP, youpi.  
Cette fois j'ai tous les paquets qui marchent, mais quand je crée le DNS en suivant tes fichiers de config, bah named ne s'exécute pas.

```
Failed to start named.service : Unit not found.
```

J'ai vérifié le contenu des 3 fichiers de config, j'ai cherché des erreurs et corrigé ce que j'ai trouvé. Mais ça a rien changé au final.  