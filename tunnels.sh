#!/bin/bash

# Run this on your MacBook to create a secure tunnel to PostgreSQL

echo "🔒 Creating SSH tunnel for PostgreSQL access..."

# SSH tunnel to Ubuntu server
ssh -L 5432:localhost:5432 -L 7575:localhost:7575 -L 8082:localhost:8082 paul@138.201.22.153

echo "✅ SSH tunnel established!"
echo "💡 PostgreSQL is now accessible at localhost:5432 on your MacBook"
echo "💡 Canton is now accessible at localhost:7575 on your MacBook"
echo "💡 Keycloak is now accessible at localhost:8082 on your MacBook"
echo "🔧 Update your MacBook environment variables:"
echo "   DATABASE_URL=postgresql://cnadmin:supersafe@localhost:5432/dserv"
echo "   PROVIDER_VALIDATOR_URL=http://localhost:7575"
echo "   USER_VALIDATOR_URL=http://localhost:7575"
echo "   KEYCLOAK_URL=http://keycloak.localhost:8082"
echo "⚠️  Keep this terminal open while you need database access"
echo "   Press Ctrl+C to close the tunnel when done"
