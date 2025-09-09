# Debugging and Service Management

## Service Control Commands

- **Start local development**: Use `./go-local.sh` (excludes DAML uploader)
- **Start production**: Use `./go-production.sh` (includes DAML uploader)
- **Stop services**: Use `./stop.sh` (stops all services including DAML uploader)

## Important Notes

- Always use the project's custom scripts instead of direct docker compose commands
- **Local development** (`./go-local.sh`): HTTP only, no SSL certificates, no DAML uploader
- **Production** (`./go-production.sh`): HTTPS with SSL certificates, includes DAML uploader
- The `stop.sh` script ensures clean shutdown and proper cleanup of all services
