#!/bin/bash

# Function to exit if a command fails
function exit_if_failed {
    "$@"
    if [ $? -ne 0 ]; then
        echo "Command failed: $@"
        exit 1
    fi
}

# Prompt for new user name, IP address, and password
read -p "Enter the new user name [wireguard]: " NEW_USER
NEW_USER=${NEW_USER:-wireguard}
read -p "Enter your server IP address: " SERVER_IP
read -sp "Enter your admin password: " ADMIN_PASSWORD
echo

# Step 1: Create a new user with sudo privileges
echo "Creating a new user with sudo privileges..."
exit_if_failed sudo adduser $NEW_USER
exit_if_failed sudo usermod -aG sudo $NEW_USER

# Switch to the new user
echo "Switching to the new user..."
exit_if_failed su - $NEW_USER

# Step 2: Install Docker
echo "Installing Docker..."
exit_if_failed sudo apt update
exit_if_failed sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
exit_if_failed curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
exit_if_failed sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
exit_if_failed sudo apt update
exit_if_failed sudo apt install docker-ce -y

# Step 3: Install Docker Compose
echo "Installing Docker Compose..."
exit_if_failed sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
exit_if_failed sudo chmod +x /usr/local/bin/docker-compose

# Step 4: Install WireGuard
echo "Installing WireGuard..."
exit_if_failed sudo apt update
exit_if_failed sudo apt install wireguard -y

# Step 5: Load WireGuard module
echo "Loading WireGuard module..."
exit_if_failed sudo modprobe wireguard

# Step 6: Create wg-easy directory and configuration
echo "Creating wg-easy directory and configuration..."
exit_if_failed mkdir ~/wg-easy
exit_if_failed cd ~/wg-easy

# Step 7: Create docker-compose.yml file
echo "Creating docker-compose.yml file..."
cat <<EOF >docker-compose.yml
version: "3.8"

services:
  wg-easy:
    environment:
      - WG_HOST=${SERVER_IP}
      - PASSWORD=${ADMIN_PASSWORD}
      - WG_PORT=51820
      - WG_DEFAULT_ADDRESS=10.8.0.x
      - WG_DEFAULT_DNS=1.1.1.1
    image: ghcr.io/wg-easy/wg-easy
    container_name: wg-easy
    ports:
      - "51821:51821/tcp"
      - "51820:51820/udp"
    volumes:
      - ~/.wg-easy:/etc/wireguard
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
EOF

# Step 8: Start the wg-easy service
echo "Starting the wg-easy service..."
exit_if_failed sudo docker-compose up -d

echo "Setup complete!"
