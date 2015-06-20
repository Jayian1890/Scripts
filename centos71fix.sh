#!/bin/sh
#CentOS 7.1 Network Fix for OpenVZ
#package mirror: http://lauvis.com/scripts/initscripts-9.49.17-1.el7.x86_64.rpm
rpm -iUvh --force "ftp://ftp.icm.edu.pl/vol/rzm5/linux-slc/centos/7.0.1406/os/x86_64/Packages/initscripts-9.49.17-1.el7.x86_64.rpm"
sed -i.bak "s/IPADDR=.*/IPADDR=127.0.0.1/" "/etc/sysconfig/network-scripts/ifcfg-venet0"
service network restart
echo "Complete"