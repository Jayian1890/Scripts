#!/bin/sh

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing base packages..."
sudo apt-get install curl systemd-resolved cifs-utils htop -y

echo "Setting name servers..."
sudo echo "nameserver 1.1.1.1" >> /etc/resolv.conf
#sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
#echo $(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}') | tee -a interface
#sudo resolvectl dns $(<interface) 1.1.1.1

echo "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

echo "Installing Tailscale package... (Interaction required)"
curl -fsSL https://tailscale.com/install.sh | sh

echo "Starting Tailscale service..."
sudo tailscale up

echo "Everything has been completed!!! Hopefully without error"
