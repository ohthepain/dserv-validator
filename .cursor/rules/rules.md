# Cursor Rules for dserv-validator Project

## CRITICAL: Authentication Configuration

### nginx-keycloak Service

- **DO NOT REMOVE** the `nginx-keycloak` service from compose.yaml
- This service is essential for proper Keycloak authentication setup
- Provides consistent port mapping (8082) for Keycloak access
- Handles CORS and proxy configuration for Keycloak
- Required for the authentication flow to work correctly
- No health check needed for nginx-keycloak
- Keycloak is accessed through nginx on port 8082, which is mapped 8082:8082

### Keycloak Service Configuration

- Keycloak should NOT expose ports directly (no `ports:` section)
- All Keycloak access should go through the nginx-keycloak proxy on port 8082
- This ensures consistent configuration and proper CORS handling

### Authentication URLs

- All authentication endpoints should use port 8082 (nginx-keycloak proxy)
- Base URL: `http://keycloak.localhost:8082`
- Admin console: `http://keycloak.localhost:8082/admin`
- JWKS endpoint: `http://keycloak.localhost:8082/realms/AppUser/protocol/openid-connect/certs`
- Token endpoint: `http://keycloak.localhost:8082/realms/AppUser/protocol/openid-connect/token`

## Environment Variables

- Always use the `setup-auth-env.sh` script to configure authentication environment variables
- Key variables: `AUTH_URL`, `AUTH_JWKS_URL`, `VALIDATOR_AUTH_CLIENT_ID`, `VALIDATOR_AUTH_CLIENT_SECRET`

## Testing

- Use `./test.sh` to verify the authentication setup is working
- The test script validates all authentication endpoints and token flows

## File Structure

- Keep the `config/nginx-keycloak/` directory with nginx configuration files
- These files are required for the nginx-keycloak proxy to function

## When Making Changes

- If modifying authentication configuration, test with `./test.sh` afterward
- Ensure all URLs in scripts and configuration files use port 8082
- Never expose Keycloak directly on port 8080 in production configuration
