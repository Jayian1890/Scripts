#!/bin/bash
if [[ "$1" != "" ]]; then

    IP_ADDRESS="$1"
	
    cd /tmp
    vzlist -o hostname,ctid,ip >> vzlist
    grep "$IP_ADDRESS" vzlist
	
else

    echo "No argument supplied"
	
fi

