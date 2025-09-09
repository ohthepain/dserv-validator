# Debugging and Service Management

## Service Control Commands

- **Start services**: Use `./go-local.sh` or `./go-production.sh` (not `docker compose up`)
- **Stop services**: Use `./stop.sh` (not `docker compose down`)

## Important Notes

- Always use the project's custom scripts instead of direct docker compose commands
- The `./go-local.sh` or `./go-production.sh` script handles proper startup sequence and environment setup
- The `stop.sh` script ensures clean shutdown and proper cleanup
