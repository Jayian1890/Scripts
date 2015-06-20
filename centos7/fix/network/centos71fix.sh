#!/bin/sh
#CentOS 7.1 Network Fix for OpenVZ
ifup venet0 && ifup venet0:0
rpm -iUvh --force "https://github.com/Tsume/Scripts/raw/master/centos7/fix/network/initscripts-9.49.17-1.el7.x86_64.rpm"
service network restart
echo "Complete"