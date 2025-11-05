#!/bin/bash
# Grant ReadAs permissions to PQS service account via HTTP API

set -eo pipefail

# Load environment variables
source ./env/app-provider.env 2>/dev/null || true
source ./env/ports.env 2>/dev/null || true

# Get admin token
echo "Getting admin token..."
TOKEN=$(curl -fsS "${AUTH_APP_PROVIDER_TOKEN_URL}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${AUTH_APP_PROVIDER_VALIDATOR_CLIENT_ID}" \
  -d "client_secret=${AUTH_APP_PROVIDER_VALIDATOR_CLIENT_SECRET}" \
  -d "grant_type=client_credentials" \
  -d "scope=openid" | jq -r .access_token)

if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
  echo "Error: Failed to get admin token"
  exit 1
fi

echo "Admin token obtained"

# Participant address (provider participant uses port 37575)
PARTICIPANT="participant:3${PARTICIPANT_JSON_API_PORT:-7575}"
PQS_USER_ID="${AUTH_APP_PROVIDER_PQS_USER_ID:-0145df12-c560-40fa-bef3-caff2c5c2224}"

# Find the party - try to find it dynamically
echo "Finding app provider party..."
PARTY=$(curl -fsS "http://${PARTICIPANT}/v2/parties/party?parties=${APP_PROVIDER_PARTY_HINT:-app_provider_dserv}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | jq -r '.partyDetails[0].party // empty')

if [ -z "$PARTY" ] || [ "$PARTY" == "null" ]; then
  echo "Error: Could not find party. Available parties:"
  curl -fsS "http://${PARTICIPANT}/v2/parties" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" | jq -r '.partyDetails[].party'
  exit 1
fi

echo "Found party: $PARTY"

# Grant ReadAs permission
echo "Granting ReadAs permission to PQS user ${PQS_USER_ID} for party ${PARTY}..."
curl -fsS "http://${PARTICIPANT}/v2/users/${PQS_USER_ID}/rights" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw "{
    \"userId\": \"${PQS_USER_ID}\",
    \"identityProviderId\": \"\",
    \"rights\": [{\"kind\":{\"CanReadAs\":{\"value\":{\"party\":\"${PARTY}\"}}}}]
  }"

echo ""
echo "Successfully granted ReadAs permission to PQS user ${PQS_USER_ID} for party ${PARTY}"

