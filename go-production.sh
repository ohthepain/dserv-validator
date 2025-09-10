#!/bin/bash

# Production startup script
# Uses keycloak-production.conf for HTTPS with SSL certificates

echo "🚀 Starting DServ Validator for PRODUCTION"
echo "   - HTTPS on port 443 with SSL certificates"
echo "   - HTTP on port 8082 for internal communication"
echo "   - keycloak.dserv.io for external access"
echo ""

# Check if SSL certificates exist
if [ ! -d "/etc/letsencrypt/live/keycloak.dserv.io" ]; then
    echo "❌ Error: SSL certificates not found!"
    echo "   Expected: /etc/letsencrypt/live/keycloak.dserv.io/"
    echo "   This script is for production deployment only."
    echo "   For local development, use: ./go-local.sh"
    exit 1
fi

# Ensure we're using the production configuration
if [ ! -f "config/nginx-keycloak/keycloak-production.conf" ]; then
    echo "❌ Error: keycloak-production.conf not found!"
    echo "   This script requires the production configuration."
    exit 1
fi

echo "📋 Starting services (including DAML uploader)..."
docker compose -f compose.yaml -f compose.prod.yaml -f compose-daml-upload.yaml up -d

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
echo "💡 For local development, use: ./go-local.sh"
