# Keycloak Configuration

Keycloak needs to work both locally and when deployed to the Ubuntu server.

## Important Notes

- We are not currently using the AppProvider realm for users. All users are in the AppUser realm.
- Please do not recreate the master realm while trying to fix things. The original master realm configuration worked fine.

## Architecture

- Keycloak runs on internal port 8082, exposed via nginx-keycloak proxy
- It uses PostgreSQL with dedicated keycloakdb database
- All internal services use HTTP for communication within the Docker network
- Realms are set to "sslRequired": "external"

## Configuration Files

### Local Development

- **File**: `config/nginx-keycloak/keycloak-local.conf`
- **Port**: 8082
- **Server Name**: keycloak.localhost
- **Access**: http://keycloak.localhost:8082

### Production

- **File**: `config/nginx-keycloak/keycloak-production.conf`
- **HTTP Port**: 8082 (internal communication)
- **HTTPS Port**: 443 (external access)
- **Server Names**: keycloak.dserv.io, dserv.io
- **Access**: https://keycloak.dserv.io (port 443)

## Access Points

### Local Development

- **Frontend**: http://keycloak.localhost:8082 (via nginx proxy)
- **Admin Console**: http://keycloak.localhost:8082/admin/master/console/
- **Backend Access**: http://nginx-keycloak:8082 (internal container communication)

### Production

- **Frontend**: https://keycloak.dserv.io (port 443)
- **Admin Console**: https://keycloak.dserv.io/admin/master/console/
- **Backend Access**: http://nginx-keycloak:8082 (internal container communication)

## nginx-keycloak Configuration

### CORS Handling

- Comprehensive CORS configuration for preflight OPTIONS requests
- Handles cross-origin requests for local development
- Adds appropriate headers for frontend applications

### Proxy Headers

- X-Real-IP, X-Forwarded-For, X-Forwarded-Proto
- Custom Forwarded header for proper Keycloak proxy detection
- Proxy Pass: Forwards all requests to http://keycloak:8082/

### Keycloak Command Line Options

- `--hostname-strict=false`: Allows flexible hostname usage
- `--proxy-headers=forwarded`: Enables proper proxy header handling

## Health Checks

Both Keycloak and nginx-keycloak have health checks to ensure proper startup order and service availability.

## SSL Configuration

- **Local**: HTTP only (no SSL certificates needed)
- **Production**: HTTPS on port 443 with Let's Encrypt certificates
- **Internal**: HTTP on port 8082 for container-to-container communication

This configuration provides a complete OAuth2/OpenID Connect setup for both local development and production deployment with proper CORS handling and seamless integration with the rest of the application stack.
