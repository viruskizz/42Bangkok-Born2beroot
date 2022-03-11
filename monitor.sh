#!/bin/bash

#Arhitecture: Linux tsomsa42 3.10.0-1160.59.1.el7.x86_64 #1 SMP Wed Feb 23 16:47:03 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
#CPU physical: 1
#vCPU: 1
#Memory Usage: 125/3346MB (3.74%)
#Disk Usage: 1/10Gb (14%)
#CPU load: 6.2%
#Last boot: 2022-03-09 16:52
#LVM use: yes
#Connexions TCP : 1 ESTABLISHED
#User log: 2
#Network: IP 192.168.1.147 (08:00:27:98:19:11)
#Sudo : 52 cmd

output="#Arhitecture : $(uname -a)
#CPU physical : $(nproc)
#vCPU : $(grep processor /proc/cpuinfo | wc -l)
#Memory Usage : $(free -m -t | awk 'NR == 4 {printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2*100)}')
#Disk Usage : $(df -h | awk '$NF=="/" {printf("%d/%dGb (%s)", $3, $2, $5)}')
#CPU load : $(top -bn1 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'| awk '{print 100-$8}')%
#Last boot : $(who -b | awk '{ printf("%s %s", $3, $4) }')
#LVM use : $(cat /etc/fstab | grep /dev/mapper/ | wc -l | awk '{if ($1 > 0) {printf("yes")} else {printf("no")}}')
#Connexions TCP : $(netstat -ant | grep ESTABLISHED | wc -l) ESTABLISHED
#User log : $(who | wc -l)
#Network : IP $(/sbin/ifconfig enp0s3 | grep "inet " | awk '{ print($2) }') ($(/sbin/ifconfig enp0s3 | grep "ether" | awk '{ print($2) }'))
#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd"

echo "$output"
