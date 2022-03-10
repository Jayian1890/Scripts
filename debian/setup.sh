#!/bin/sh
SSH_DIR=~/.ssh
SSH_KEYS=authorized_keys
SSH_PORT=22
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAykZ1FVy8AJLv52aKZnMbPE2S9tcHi37/Rc1Z6fRhr++3PR9OZvNubLRU2iGObjD15LHuSI+m7Na0ZAkQMd7F/it4WhA9tTZyW0BEZGOhSIeXp+e3JLzt9DHBcwIG0ZEYqCFIdVjxoT0BzmUmmwmu2ZG8t07WE9m3W30sFOCp3f0= rsa-key-20130113"

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install htop -y

echo "Adding ssh key to authorized_keys..."
if [ ! -d "$SSH_DIR" ]; then
	mkdir ~/.ssh
	if [ ! -f "$SSH_DIR/$SSH_KEYS" ]; then
		touch ~/.ssh/authorized_keys
	fi
fi
echo "$PUB_KEY" >> ~/.ssh/authorized_keys

echo "Setting permissions..."
sudo chmod 700 $SSH_DIR
sudo chmod 600 "$SSH_DIR/$SSH_KEYS"

echo "Restarting ssh..."
sudo service ssh restart
