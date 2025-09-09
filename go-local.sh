#!/bin/bash

# Local development startup script
# Uses keycloak-local.conf for HTTP-only development

echo "🚀 Starting DServ Validator for LOCAL DEVELOPMENT"
echo "   - HTTP only (no SSL certificates needed)"
echo "   - Port 8082 for Keycloak access"
echo "   - keycloak.localhost for local development"
echo ""

# Ensure we're using the local configuration
if [ ! -f "config/nginx-keycloak/keycloak-local.conf" ]; then
    echo "❌ Error: keycloak-local.conf not found!"
    echo "   This script requires the local development configuration."
    exit 1
fi

# Check if compose.yaml is configured for local
if grep -q "keycloak-local.conf" compose.yaml; then
    echo "✅ Using local development configuration"
else
    echo "❌ Error: compose.yaml not configured for local development!"
    echo "   Expected: keycloak-local.conf in nginx-keycloak volumes"
    exit 1
fi

echo "📋 Starting services (excluding DAML uploader)..."
docker compose up -d

echo ""
echo "🌐 Access Points:"
echo "   - Keycloak Admin: http://keycloak.localhost:8082/admin"
echo "   - Health Check:  http://localhost:8082/health"
echo "   - Main App:      http://localhost"
echo ""
echo "💡 For production deployment, use: ./go-production.sh"
