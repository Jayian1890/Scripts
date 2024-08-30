#!/bin/sh

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing base packages..."
sudo apt-get install curl systemd-resolved cifs-utils htop -y

echo "Linking stub-resolv config file..."
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo "Setting name servers..."
echo $(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}') | tee -a interface
IFACE=$(<interface)
sudo resolvectl dns $IFACE 1.1.1.1 && sudo systemctl restart systemd-resolved

echo "Installing Tailscale package... (Interaction required)"
curl -fsSL https://tailscale.com/install.sh | sh

echo "Starting Tailscale service..."
sudo tailscale up

echo "Setting up Samba client..."
sudo echo 'user=jayian' | sudo tee /.smbcredentials
sudo echo 'password=Admins!@!301' | sudo tee -a /.smbcredentials
sudo echo "//MediaServer/media /media cifs credentials=/.smbcredentials,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload 

echo "Mounting samba NFS to /media"
sudo mount -a

echo "Everything has been completed!!! Hopefully without error"
