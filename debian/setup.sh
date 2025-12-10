#!/bin/sh
set -e

#############################################
# Prompt for new user
#############################################
echo "Enter a username to create:"
read NEW_USER

if ! echo "$NEW_USER" | grep -Eq '^[a-zA-Z0-9_-]+$'; then
    echo "Invalid username. Allowed: letters, numbers, underscores, hyphens."
    exit 1
fi

#############################################
# Create user if missing and add to sudo
#############################################
if id "$NEW_USER" >/dev/null 2>&1; then
    echo "User '$NEW_USER' already exists."
else
    echo "Creating user '$NEW_USER'..."
    sudo adduser --disabled-password --gecos "" "$NEW_USER"
fi

echo "Adding '$NEW_USER' to sudo group..."
sudo usermod -aG sudo "$NEW_USER"

#############################################
# SSH key management
#############################################
SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnIBwTJTGAsgpMvrMQu3HtNEKdhHAX0NztaCthKkqYe rpi-key-20251023"

USER_SSH_DIR="/home/$NEW_USER/.ssh"
USER_AUTH_KEYS="$USER_SSH_DIR/authorized_keys"

echo "Ensuring SSH directory exists..."
sudo mkdir -p "$USER_SSH_DIR"
sudo chmod 700 "$USER_SSH_DIR"
sudo chown "$NEW_USER:$NEW_USER" "$USER_SSH_DIR"

echo "Checking for existing SSH key..."
if [ -f "$USER_AUTH_KEYS" ] && grep -q "$SSH_KEY" "$USER_AUTH_KEYS"; then
    echo "SSH key already exists for user."
else
    echo "Adding SSH key for user..."
    echo "$SSH_KEY" | sudo tee -a "$USER_AUTH_KEYS" >/dev/null
fi

sudo chmod 600 "$USER_AUTH_KEYS"
sudo chown "$NEW_USER:$NEW_USER" "$USER_AUTH_KEYS"

echo "SSH key configured for $NEW_USER"


#############################################
# Hostname Prompt
#############################################
echo "Enter a hostname for this device (letters, numbers, hyphens only):"
read NEW_HOSTNAME

if ! echo "$NEW_HOSTNAME" | grep -Eq '^[a-zA-Z0-9-]+$'; then
    echo "Invalid hostname. Allowed: letters, numbers, hyphens."
    exit 1
fi

echo "Setting hostname to: $NEW_HOSTNAME"
sudo hostnamectl set-hostname "$NEW_HOSTNAME"

if grep -q "^127\.0\.1\.1" /etc/hosts; then
    sudo sed -i "s/^127\.0\.1\.1.*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts
else
    echo "127.0.1.1 $NEW_HOSTNAME" | sudo tee -a /etc/hosts >/dev/null
fi

echo "Hostname updated."


#############################################
# SSH Port Prompt
#############################################
echo "Enter a new SSH port (optional). Press ENTER for default (22):"
read SSH_PORT

if [ -z "$SSH_PORT" ]; then
    SSH_PORT=22
fi

if ! echo "$SSH_PORT" | grep -Eq '^[0-9]+$' || [ "$SSH_PORT" -lt 1 ] || [ "$SSH_PORT" -gt 65535 ]; then
    echo "Invalid port. Must be a number between 1 and 65535."
    exit 1
fi

echo "Using SSH port: $SSH_PORT"


#############################################
# System Update
#############################################
echo "Updating system..."
sudo apt-get update
sudo apt-get upgrade -y


#############################################
# Install Packages
#############################################
echo "Installing base packages..."
sudo apt-get install -y \
    curl \
    systemd-resolved \
    htop \
    ufw \
    openssh-server


#############################################
# Configure DNS
#############################################
echo "Configuring DNS with systemd-resolved..."
IFACE=$(ip -o link show | awk -F': ' '!/lo|vir|wl/{print $2; exit}')

if [ -n "$IFACE" ]; then
    sudo resolvectl dns "$IFACE" 1.1.1.1
    sudo resolvectl domain "$IFACE" "~."
else
    echo "WARNING: No suitable network interface found. DNS not configured."
fi

echo "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved


#############################################
# Configure SSH Daemon
#############################################
echo "Configuring SSH to use port $SSH_PORT..."

sudo sed -i "s/^#Port .*/Port $SSH_PORT/" /etc/ssh/sshd_config
sudo sed -i "s/^Port .*/Port $SSH_PORT/" /etc/ssh/sshd_config

if ! grep -q "^Port $SSH_PORT" /etc/ssh/sshd_config; then
    echo "Port $SSH_PORT" | sudo tee -a /etc/ssh/sshd_config >/dev/null
fi

sudo systemctl reload sshd
echo "SSH daemon reloaded."


#############################################
# Configure Firewall
#############################################
echo "Configuring firewall..."

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow "$SSH_PORT/tcp"

sudo ufw --force enable

echo "Firewall enabled. Only port $SSH_PORT is open."


#############################################
# Install Tailscale
#############################################
echo "Installing Tailscale package..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "Starting Tailscale..."
sudo tailscale up \
    --auth-key=tskey-auth-kaWv2Zgbeg11CNTRL-6smfzUbJyqCrKAmrfuCHiCjt5uBtihHj \
    --advertise-exit-node \
    --hostname="$NEW_HOSTNAME"

echo "Completed."
