#!/sh/bin
IP_ADDRESS=$1

if [ -z "$1" ]
  then
    echo "No argument supplied"
  else
	cd /tmp
	vzlist -o hostname,ctid,ip >> vzlist
	grep "$IP_ADDRESS" vzlist
fi

