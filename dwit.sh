TOKEN_URL="http://localhost:8082/realms/AppProvider/protocol/openid-connect/token"
CLIENT_ID="app-provider-validator"
CLIENT_SECRET="pQagV9Fmy1S6HInFIAfUgUC9ZYG0btf0"
PQS_USER_ID="0145df12-c560-40fa-bef3-caff2c5c2224"
PARTY_ID="app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402"
PARTICIPANT="localhost:37575"  # Since we are running from host, not in the container

echo "Getting admin token from ${TOKEN_URL}..."
TOKEN=$(curl -fsS "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  -d "scope=openid" | jq -r .access_token)

if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
  echo "Error: Failed to get admin token"
  exit 1
fi

echo "Token obtained successfully"

# Grant ReadAs permission
echo "Granting ReadAs permission to PQS user ${PQS_USER_ID} for party ${PARTY_ID}..."
RESPONSE=$(curl -fsS -w "\n%{http_code}" "http://${PARTICIPANT}/v2/users/${PQS_USER_ID}/rights" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw "{
    \"userId\": \"${PQS_USER_ID}\",
    \"identityProviderId\": \"\",
    \"rights\": [{\"kind\":{\"CanReadAs\":{\"value\":{\"party\":\"${PARTY_ID}\"}}}}]
  }")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" == "200" ]; then
  echo "Successfully granted ReadAs permission!"
  echo "$BODY" | jq .
else
  echo "Error: HTTP $HTTP_CODE"
  echo "$BODY"
  exit 1
fi
 
