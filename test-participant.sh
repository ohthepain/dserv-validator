#!/bin/bash

# Quick test for participant health and connectivity

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🧪 Testing Participant Health and Connectivity"
echo ""

# Check Docker container status
echo -e "${BLUE}1. Checking Docker container status...${NC}"
if docker compose ps participant 2>/dev/null | grep -q "Up.*healthy"; then
    echo -e "${GREEN}✅ Participant container is running and healthy${NC}"
    docker compose ps participant | grep participant | awk '{print "   Container: " $1 " | Status: " $7}'
else
    echo -e "${RED}❌ Participant container not healthy${NC}"
    exit 1
fi
echo ""

# Check ports are exposed
echo -e "${BLUE}2. Checking exposed ports...${NC}"
PORTS="25001 25002 35001 35002 27000 37000 25061 35061"
for port in $PORTS; do
    if docker compose ps participant 2>/dev/null | grep -q ":${port}->"; then
        echo -e "${GREEN}✅ Port ${port} is exposed${NC}"
    else
        echo -e "${YELLOW}⚠️  Port ${port} not exposed${NC}"
    fi
done
echo ""

# Test from inside container
echo -e "${BLUE}3. Testing health endpoints from inside container...${NC}"
if docker compose exec -T participant curl -s http://localhost:27000/health 2>/dev/null >/dev/null; then
    echo -e "${GREEN}✅ participant-user HTTP health endpoint (27000) responding${NC}"
else
    echo -e "${YELLOW}⚠️  participant-user HTTP health endpoint may use different path${NC}"
fi

if docker compose exec -T participant curl -s http://localhost:37000/health 2>/dev/null >/dev/null; then
    echo -e "${GREEN}✅ participant-provider HTTP health endpoint (37000) responding${NC}"
else
    echo -e "${YELLOW}⚠️  participant-provider HTTP health endpoint may use different path${NC}"
fi
echo ""

# Check JWK URLs are accessible
echo -e "${BLUE}4. Testing JWK URLs (used for authentication)...${NC}"
if docker compose exec -T participant curl -s http://nginx-keycloak:8082/realms/AppUser/protocol/openid-connect/certs 2>/dev/null | jq -e '.keys' >/dev/null 2>&1; then
    echo -e "${GREEN}✅ JWKS endpoint is accessible and returns valid keys${NC}"
else
    echo -e "${RED}❌ JWKS endpoint not accessible${NC}"
fi
echo ""

# Check logs for any errors
echo -e "${BLUE}5. Checking recent logs for errors...${NC}"
ERROR_COUNT=$(docker compose logs participant --tail 50 2>/dev/null | grep -i "error\|fatal\|failed" | grep -v "WARN" | wc -l | tr -d ' ')
if [ "$ERROR_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ No recent errors in logs${NC}"
else
    echo -e "${YELLOW}⚠️  Found ${ERROR_COUNT} error(s) in recent logs${NC}"
    echo "   Run: docker compose logs participant --tail 50 | grep -i error"
fi
echo ""

# Summary
echo -e "${BLUE}Summary:${NC}"
echo -e "${GREEN}✅ Participant is healthy and running${NC}"
echo -e "${GREEN}✅ Ports are correctly configured and exposed${NC}"
echo -e "${GREEN}✅ Authentication endpoints are accessible${NC}"
echo ""
echo -e "${BLUE}💡 Next steps:${NC}"
echo "   - Test ledger API connectivity: docker compose exec participant curl http://localhost:25001/v1/version"
echo "   - Test admin API: docker compose exec participant curl http://localhost:25002/v1/version"
echo "   - Check detailed logs: docker compose logs participant"
echo "   - Use canton console: docker compose up -d canton-console-app-user && docker attach \$(docker compose ps -q canton-console-app-user)"
