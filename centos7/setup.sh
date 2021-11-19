#!/bin/sh
SSH_DIR=~/.ssh
SSH_KEYS=authorized_keys
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAykZ1FVy8AJLv52aKZnMbPE2S9tcHi37/Rc1Z6fRhr++3PR9OZvNubLRU2iGObjD15LHuSI+m7Na0ZAkQMd7F/it4WhA9tTZyW0BEZGOhSIeXp+e3JLzt9DHBcwIG0ZEYqCFIdVjxoT0BzmUmmwmu2ZG8t07WE9m3W30sFOCp3f0= rsa-key-20130113"

echo "Adding ssh key to authorized_keys..."
if [ ! -d "$SSH_DIR" ]; then
	mkdir ~/.ssh
	if [ ! -f "$SSH_DIR/$SSH_KEYS" ]; then
		touch ~/.ssh/authorized_keys
	fi
fi
echo "$PUB_KEY" >> ~/.ssh/authorized_keys

echo "Setting permissions..."
chmod 700 $SSH_DIR
chmod 600 "$SSH_DIR/$SSH_KEYS"

echo "Disabling password logins..."
sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" "/etc/ssh/sshd_config"

echo "Restarting ssh..."
service sshd restart

echo "Updating system..."
yum install epel-release -y && yum install htop -y && yum update -y
