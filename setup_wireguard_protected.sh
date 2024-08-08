#!/bin/bash

# Function to exit if a command fails
function exit_if_failed {
    "$@"
    if [ $? -ne 0 ]; then
        echo "Command failed: $@"
        exit 1
    fi
}

# Prompt for IP address and password
read -p "Enter your server IP address: " SERVER_IP
read -sp "Enter your admin password: " ADMIN_PASSWORD
echo

# Step 1: Install Docker
echo "Installing Docker..."
exit_if_failed curl -sSL https://get.docker.com | sh
exit_if_failed sudo usermod -aG docker $(whoami)

# Step 2: Start the wg-easy container
echo "Starting the wg-easy container..."
exit_if_failed docker run -d \
  --name=wg-easy \
  -e LANG=de \
  -e WG_HOST=${SERVER_IP} \
  -e PASSWORD=${ADMIN_PASSWORD} \
  -e PORT=51821 \
  -e WG_PORT=51820 \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  ghcr.io/wg-easy/wg-easy

echo "Setup complete!"
