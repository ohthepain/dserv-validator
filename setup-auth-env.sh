#!/bin/bash

# Setup authentication environment variables for AppUser realm
# This script should be run after Keycloak is up and running

echo "Setting up authentication environment variables for AppUser realm..."

# Base URL for Keycloak (via nginx proxy)
KEYCLOAK_BASE_URL="http://keycloak.localhost:8082"

# AppUser realm name
REALM_NAME="AppUser"

# Set environment variables
export AUTH_URL="${KEYCLOAK_BASE_URL}"
export AUTH_WELLKNOWN_URL="${KEYCLOAK_BASE_URL}/realms/${REALM_NAME}/.well-known/openid_configuration"
export AUTH_JWKS_URL="${KEYCLOAK_BASE_URL}/realms/${REALM_NAME}/protocol/openid-connect/certs"

# Client IDs from the AppUser realm
export VALIDATOR_AUTH_CLIENT_ID="app-user-validator"
export WALLET_UI_CLIENT_ID="app-user-wallet"
export ANS_UI_CLIENT_ID="app-user-unsafe"

# Client secrets from the AppUser realm
export VALIDATOR_AUTH_CLIENT_SECRET="6m12QyyGl81d9nABWQXMycZdXho6ejEX"

# Audiences
export VALIDATOR_AUTH_AUDIENCE="https://canton.network.global"
export LEDGER_API_AUTH_AUDIENCE="https://canton.network.global"

# Admin users
export LEDGER_API_ADMIN_USER="ledger-api-user"
export WALLET_ADMIN_USER="administrator"

echo "Environment variables set:"
echo "AUTH_URL=${AUTH_URL}"
echo "AUTH_WELLKNOWN_URL=${AUTH_WELLKNOWN_URL}"
echo "AUTH_JWKS_URL=${AUTH_JWKS_URL}"
echo "VALIDATOR_AUTH_CLIENT_ID=${VALIDATOR_AUTH_CLIENT_ID}"
echo "VALIDATOR_AUTH_CLIENT_SECRET=${VALIDATOR_AUTH_CLIENT_SECRET}"
echo "WALLET_UI_CLIENT_ID=${WALLET_UI_CLIENT_ID}"
echo "ANS_UI_CLIENT_ID=${ANS_UI_CLIENT_ID}"
echo "VALIDATOR_AUTH_AUDIENCE=${VALIDATOR_AUTH_AUDIENCE}"
echo "LEDGER_API_AUTH_AUDIENCE=${LEDGER_API_AUTH_AUDIENCE}"
echo ""
echo "To use these variables in your current shell, run:"
echo "source setup-auth-env.sh"
echo ""
echo "Or add them to your .env file or export them manually."
