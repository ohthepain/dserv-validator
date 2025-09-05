# Keycloak

keycloak needs to work both locally and when deployed to the ubuntu server.

we are not currently using the AppProvider realm for users. all users are in the AppUser realm.

please do not recreate the master realm while trying to fix things. the original master realm configuration worked fine.

Keycloak runs on internal port 8082, exposed via nginx-keycloak proxy
It uses PostgreSQL with dedicated keycloakdb database

Access Points
Frontend: http://localhost:8082 (via nginx proxy)
http://localhost:8082/admin/master/console/

# nginx-keycloak Configuration

- Port: Exposes port 8082 to host
- Network Alias: keycloak.localhost for local development
  Nginx Configuration (config/nginx-keycloak/keycloak.conf):
- Server: Listens on port 8082 with hostname keycloak.localhost
- CORS Handling: Comprehensive CORS configuration for preflight OPTIONS requests
- Proxy Headers: Proper forwarding of headers including:
- X-Real-IP, X-Forwarded-For, X-Forwarded-Proto
- Custom Forwarded header for proper Keycloak proxy detection
- Proxy Pass: Forwards all requests to http://keycloak:8082/

# URL Configuration:

- Frontend Access: http://keycloak.localhost:8082 (via nginx proxy)
- Backend Access: http://nginx-keycloak:8082 (internal container communication)
- Admin Console: http://keycloak.localhost:8082/admin

#Development-Specific Features

CORS Configuration:
The nginx proxy handles CORS preflight requests and adds appropriate headers for local development, allowing frontend applications to communicate with Keycloak.
Hostname Flexibility:

- --hostname-strict=false allows flexible hostname usage
- --proxy-headers=forwarded enables proper proxy header handling

# Health Checks:

Both Keycloak and nginx-keycloak have health checks to ensure proper startup order and service availability.
This configuration provides a complete OAuth2/OpenID Connect setup for local development with proper CORS handling, multiple realms for different user types, and seamless integration with the rest of the application stack.
