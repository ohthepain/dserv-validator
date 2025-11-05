# Set these variables first
TOKEN_URL="http://nginx-keycloak:8082/realms/AppProvider/protocol/openid-connect/token"
CLIENT_ID="app-provider-validator"
CLIENT_SECRET="pQagV9Fmy1S6HInFIAfUgUC9ZYG0btf0"
PQS_USER_ID="0145df12-c560-40fa-bef3-caff2c5c2224"
PARTY_ID="app_provider_dserv-validator-1::1220082dccd8ff6aeee648630d542ebd7ed6141951210aa86652fc10c7253fd17402"
PARTICIPANT="localhost:37575"  # "participant:37575" or "localhost:37575" from host

# Get token
TOKEN=$(curl -fsS "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  -d "scope=openid" | jq -r .access_token)

# Grant ReadAs permission
curl -fsS "http://${PARTICIPANT}/v2/users/${PQS_USER_ID}/rights" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw "{
    \"userId\": \"${PQS_USER_ID}\",
    \"identityProviderId\": \"\",
    \"rights\": [{\"kind\":{\"CanReadAs\":{\"value\":{\"party\":\"${PARTY_ID}\"}}}}]
  }"
 
