#!/bin/bash

# Firewall configuration for PostgreSQL access
# Only allows your MacBook IP to access PostgreSQL

echo "🔒 Configuring firewall for PostgreSQL access..."

# Get MacBook IP address
echo "📱 Please provide your MacBook's IP address:"
read -p "MacBook IP address: " MACBOOK_IP

if [ -z "$MACBOOK_IP" ]; then
    echo "❌ Error: MacBook IP address is required"
    echo "💡 You can find your MacBook's IP by running: ifconfig | grep 'inet ' | grep -v 127.0.0.1"
    exit 1
fi

echo "🔍 Configuring firewall for MacBook IP: $MACBOOK_IP"

# Reset firewall to default state
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp comment 'SSH'

# Allow HTTP and HTTPS for web services
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Allow Keycloak ports
sudo ufw allow 8082/tcp comment 'Keycloak'
sudo ufw allow 8083/tcp comment 'Keycloak Alt'

# SECURITY: Allow PostgreSQL access ONLY from your MacBook
sudo ufw allow from $MACBOOK_IP to any port 5432 comment "PostgreSQL - MacBook Access Only"

# Block PostgreSQL from all other sources
sudo ufw deny 5432/tcp comment 'PostgreSQL - Blocked from public'

# Allow Docker internal communication
sudo ufw allow in on docker0 comment 'Docker internal network'
sudo ufw allow out on docker0 comment 'Docker internal network'

# Enable firewall
sudo ufw --force enable

echo "✅ Firewall configured successfully!"
echo ""
echo "📋 Current firewall status:"
sudo ufw status verbose

echo ""
echo "🔧 POSTGRESQL ACCESS:"
echo "✅ PostgreSQL (port 5432): Accessible from MacBook ($MACBOOK_IP) only"
echo "✅ All other IP addresses are blocked from accessing PostgreSQL"
echo ""
echo "💡 CONNECTION DETAILS FOR YOUR MACBOOK:"
echo "   DATABASE_URL=postgresql://cnadmin:supersafe@138.201.22.153:5432/dserv"
echo ""
echo "⚠️  SECURITY NOTES:"
echo "1. PostgreSQL is ONLY accessible from your MacBook ($MACBOOK_IP)"
echo "2. All other IP addresses are blocked from accessing PostgreSQL"
echo "3. Web services remain accessible for normal use"
