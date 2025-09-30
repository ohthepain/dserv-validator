#!/bin/bash

# Simple production startup script
# Uses .env file and production configuration

echo "🚀 Starting DServ Validator for PRODUCTION"
echo "   - HTTPS on port 443 with SSL certificates"
echo "   - HTTP on port 8082 for internal communication"
echo "   - keycloak.dserv.io for external access"
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "   Please create a .env file with your configuration."
    exit 1
fi

echo "✅ Using .env file for configuration"

# Check if SSL certificates exist
if [ ! -d "/etc/letsencrypt/live/keycloak.dserv.io" ]; then
    echo "⚠️  Warning: SSL certificates not found!"
    echo "   Expected: /etc/letsencrypt/live/keycloak.dserv.io/"
    echo "   Production HTTPS may not work without certificates."
    echo ""
fi

# Ensure we're using the production configuration
if [ ! -f "config/nginx-keycloak/keycloak-production.conf" ]; then
    echo "❌ Error: keycloak-production.conf not found!"
    echo "   This script requires the production configuration."
    exit 1
fi

# Clean up any existing containers and networks
echo "🧹 Cleaning up existing containers..."
docker compose down --remove-orphans 2>/dev/null || true

# Start the services
echo "📋 Starting production services..."
echo "   Using: compose.yaml + compose.prod.yaml"

if docker compose -f compose.yaml -f compose.prod.yaml up -d; then
    echo ""
    echo "✅ Services started successfully!"
    echo ""
    echo "🌐 Access Points:"
    echo "   - Keycloak Admin: https://keycloak.dserv.io/admin"
    echo "   - Health Check:   https://keycloak.dserv.io/health"
    echo "   - Internal HTTP:  http://keycloak.dserv.io:8082/health"
    echo "   - Main App:       http://localhost"
    echo ""
    echo "🔒 SSL Configuration:"
    echo "   - Certificates: /etc/letsencrypt/live/keycloak.dserv.io/"
    echo "   - HTTPS Port: 443"
    echo "   - HTTP Port: 8082 (internal only)"
    echo ""
    echo "📊 Check status with: docker compose -f compose.yaml -f compose.prod.yaml ps"
    echo "📋 View logs with: docker compose -f compose.yaml -f compose.prod.yaml logs -f"
    echo ""
    echo "💡 To upload DARs: docker compose -f compose.yaml -f compose-daml-upload.yaml up daml-uploader"
else
    echo ""
    echo "❌ Failed to start services!"
    echo "   Check logs with: docker compose -f compose.yaml -f compose.prod.yaml logs"
    exit 1
fi
