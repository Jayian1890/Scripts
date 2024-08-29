#!/bin/sh
SSH_DIR=~/.ssh
SSH_KEYS=authorized_keys
SSH_PORT=22
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDn7fiB5uKn1/FXfsGKE7Ov/xELksI7srTyFJ4ncjTdw6HhEpXEsAXVtR51BT+GzOFFrl5nwyNtsC8wGTviGUO/srWuWHRiol6xZ9K0+7jKK/53bXoiZ1CCb0HYJ2FN759uLmn4kX2nm/cvbBNPpyGUT0tWoVKMNfkRfdReFh08zpeCe8m+uBYuUEMaItIhg+uUzdH3IK3EhTpy53xqhn2XVLKzo77f3c1kpsupyiBCm5g5nnLjajt2B4bqHexwMQXXj/HhPYvsT5aMgVEY9ta5P/tjaZ90FEi4QkIQl+2a074ozHcUJ7UFDVcNVbDdZUaPV6gfVQ19NtTLV7v1gwT79xCzAKR4+CY3BK0MS2dGfOhktC+FAa19l5THnskGNmQ0hyDdVvlGxQwIN8tx2TgHzhiKEM8kq0wil/Bb14ikC3fd5W9jG3XqUVRysfDClkIvrnf0i8CbYS1gsoDPYPsdgVv80cXTjtb3W8LX4go7zYoGGp8DVJVtZQxD20t3VEM= jared@interlacedpixel.com"

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing base packages..."
sudo apt-get install curl systemd-resolved cifs-utils htop -y

echo "Installing Tailscale package... (Interaction required)"
curl -fsSL https://tailscale.com/install.sh | sh

echo "Starting Tailscale service..."
sudo tailscale up

echo "Linking stub-resolv config file..."
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

#echo "Setting name servers..."
#sudo resolvectl dns ens192 1.1.1.1

#echo "Restarting systemd-resolved..."
#sudo systemctl restart systemd-resolved

echo "Setting up Samba client..."
sudo echo 'user=jayian' | sudo tee /.smbcredentials
sudo echo 'password=Admins!@!301' | sudo tee -a /.smbcredentials
sudo echo "//MediaServer/media /media cifs credentials=/.smbcredentials,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload 

echo "Mounting samba NFS to /media"
sudo mount -a

echo "Everything has been completed!!! Hopefully without error"
