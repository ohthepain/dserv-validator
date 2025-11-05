TOKEN_URL="http://localhost:8082/realms/AppProvider/protocol/openid-connect/token"
CLIENT_ID="app-provider-validator"
CLIENT_SECRET="pQagV9Fmy1S6HInFIAfUgUC9ZYG0btf0"
PQS_USER_ID="0145df12-c560-40fa-bef3-caff2c5c2224"
PQS_USER_NAME="service-account-app-provider-pqs"
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

# Check if user exists in participant, create if not (following quickstart pattern)
echo "Checking if PQS service account user ${PQS_USER_ID} exists in participant..."
USER_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://${PARTICIPANT}/v2/users/${PQS_USER_ID}" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if [ "$USER_CODE" == "404" ]; then
  echo "User does not exist in participant, creating user ${PQS_USER_ID}..."
  CREATE_RESPONSE=$(curl -fsS -w "\n%{http_code}" "http://${PARTICIPANT}/v2/users" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data-raw "{
      \"user\": {
        \"id\": \"${PQS_USER_ID}\",
        \"isDeactivated\": false,
        \"primaryParty\": \"${PARTY_ID}\",
        \"identityProviderId\": \"\",
        \"metadata\": {
          \"resourceVersion\": \"\",
          \"annotations\": {
            \"username\": \"${PQS_USER_NAME}\"
          }
        }
      },
      \"rights\": []
    }")
  
  CREATE_CODE=$(echo "$CREATE_RESPONSE" | tail -n1)
  CREATE_BODY=$(echo "$CREATE_RESPONSE" | sed '$d')
  
  if [ "$CREATE_CODE" == "200" ]; then
    echo "User created successfully in participant"
    echo "$CREATE_BODY" | jq -r .user.id
  else
    echo "Error creating user: HTTP $CREATE_CODE"
    echo "$CREATE_BODY"
    exit 1
  fi
elif [ "$USER_CODE" == "200" ]; then
  echo "User already exists in participant (HTTP $USER_CODE)"
else
  echo "Warning: Unexpected status code when checking user: HTTP $USER_CODE"
  echo "Continuing anyway to try granting permissions..."
fi

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
 
