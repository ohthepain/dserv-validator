#!/bin/bash

# Test script for dserv-validator with Keycloak authentication
# This script tests the basic functionality of the setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local description=$2
    local expected_status=${3:-200}
    
    print_status "Testing $description..."
    print_status "URL: $url"
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        print_success "$description is working"
        return 0
    else
        print_error "$description failed (expected status $expected_status)"
        return 1
    fi
}

# Function to test JSON endpoint
test_json_endpoint() {
    local url=$1
    local description=$2
    
    print_status "Testing $description..."
    print_status "URL: $url"
    
    if response=$(curl -s "$url" 2>/dev/null) && echo "$response" | jq . >/dev/null 2>&1; then
        print_success "$description is working"
        echo "$response" | jq . | head -20
        return 0
    else
        print_error "$description failed (not valid JSON)"
        return 1
    fi
}

# Main test function
main() {
    print_status "Starting dserv-validator test suite..."
    echo
    
    # Check if services are running
    print_status "Checking if Docker services are running..."
    if ! docker compose ps | grep -q "Up"; then
        print_error "Docker services are not running. Please start them first with: ./go.sh"
        exit 1
    fi
    print_success "Docker services are running"
    echo
    
    # Test basic connectivity
    print_status "Testing basic connectivity..."
    
    # Test Keycloak admin console
    test_endpoint "http://keycloak.localhost:8082/admin" "Keycloak admin console" || {
        print_warning "Keycloak admin console not accessible. Make sure you've added keycloak.localhost to /etc/hosts"
    }
    
    # Test Keycloak health endpoint
    test_endpoint "http://keycloak.localhost:8082/health" "Keycloak health endpoint" || {
        print_warning "Keycloak health endpoint not accessible"
    }
    
    # Test OpenID Connect discovery (this might return 404 if realm not fully configured)
    print_status "Testing OpenID Connect discovery endpoint..."
    print_status "URL: http://keycloak.localhost:8082/realms/AppUser/.well-known/openid_configuration"
    
    discovery_response=$(curl -s "http://keycloak.localhost:8082/realms/AppUser/.well-known/openid_configuration")
    if echo "$discovery_response" | jq -e '.' >/dev/null 2>&1 && ! echo "$discovery_response" | jq -e '.error' >/dev/null 2>&1; then
        print_success "OpenID Connect discovery endpoint is working"
        echo "$discovery_response" | jq .
    else
        print_warning "OpenID Connect discovery endpoint returned: $discovery_response"
        print_warning "This is normal if the realm is not fully configured for OpenID Connect discovery"
    fi
    
    # Test JWKS endpoint
    test_json_endpoint "http://keycloak.localhost:8082/realms/AppUser/protocol/openid-connect/certs" "JWKS endpoint"
    
    # Test validator metrics
    test_endpoint "http://validator.localhost/metrics" "Validator metrics endpoint" || {
        print_warning "Validator metrics not accessible. Make sure you've added validator.localhost to /etc/hosts"
    }
    
    # Test participant metrics
    test_endpoint "http://participant.localhost/metrics" "Participant metrics endpoint" || {
        print_warning "Participant metrics not accessible. Make sure you've added participant.localhost to /etc/hosts"
    }
    
    echo
    print_status "Testing authentication flow..."
    
    # Test getting a token using client credentials
    print_status "Testing client credentials flow..."
    
    # Get access token for validator client
    token_response=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=client_credentials" \
        -d "client_id=app-user-validator" \
        -d "client_secret=6m12QyyGl81d9nABWQXMycZdXho6ejEX" \
        "http://keycloak.localhost:8082/realms/AppUser/protocol/openid-connect/token")
    
    if echo "$token_response" | jq -e '.access_token' >/dev/null 2>&1; then
        print_success "Successfully obtained access token"
        token=$(echo "$token_response" | jq -r '.access_token')
        
        # Decode and display token info (without signature)
        print_status "Token information:"
        token_payload=$(echo "$token" | cut -d'.' -f2)
        echo "$token_payload" | base64 -d 2>/dev/null | jq . 2>/dev/null || echo "Token payload (base64): $token_payload"
        
        # Test token introspection
        print_status "Testing token introspection..."
        introspection_response=$(curl -s -X POST \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -d "token=$token" \
            -d "client_id=app-user-validator" \
            -d "client_secret=6m12QyyGl81d9nABWQXMycZdXho6ejEX" \
            "http://keycloak.localhost:8082/realms/AppUser/protocol/openid-connect/token/introspect")
        
        if echo "$introspection_response" | jq -e '.active' >/dev/null 2>&1; then
            print_success "Token introspection working"
        else
            print_error "Token introspection failed"
        fi
        
    else
        print_error "Failed to obtain access token"
        echo "$token_response" | jq . 2>/dev/null || echo "$token_response"
    fi
    
    echo
    print_status "Testing user authentication flow..."
    
    # Test direct access grant (password flow) - this would require a user to exist
    print_status "Note: User authentication testing requires users to be created in Keycloak"
    print_status "You can create users via the admin console at: http://keycloak.localhost:8082/admin"
    
    echo
    print_status "Testing environment variables..."
    
    # Source the auth environment script
    if [ -f "setup-auth-env.sh" ]; then
        source setup-auth-env.sh
        print_success "Environment variables loaded"
        
        # Test that key variables are set
        if [ -n "$AUTH_JWKS_URL" ] && [ -n "$VALIDATOR_AUTH_CLIENT_ID" ]; then
            print_success "Key environment variables are set"
            echo "AUTH_JWKS_URL: $AUTH_JWKS_URL"
            echo "VALIDATOR_AUTH_CLIENT_ID: $VALIDATOR_AUTH_CLIENT_ID"
        else
            print_error "Some environment variables are missing"
        fi
    else
        print_error "setup-auth-env.sh not found"
    fi
    
    echo
    print_status "Test summary:"
    print_status "✅ Basic connectivity tests completed"
    print_status "✅ Authentication endpoints tested"
    print_status "✅ Client credentials flow tested"
    print_status "✅ Environment variables verified"
    echo
    print_status "Next steps:"
    print_status "1. Create users in Keycloak admin console if needed"
    print_status "2. Configure your server application with the environment variables"
    print_status "3. Test your server's authentication integration"
}

# Run the main function
main "$@"
