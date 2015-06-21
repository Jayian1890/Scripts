#!/bin/sh
#CentOS 7.1 Network Fix for OpenVZ
ifup venet0:0
sed -i.bak "264s/.*/\/sbin\/arping -q -c 2 -w \$\{ARPING_WAIT:-3\} -D -I \$\{parent_device\} \$\{IPADDR\}\nif [ $? = 1 ]; then/g" "/etc/sysconfig/network-scripts/ifup-aliases"
service network restart
echo "Complete"