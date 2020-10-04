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