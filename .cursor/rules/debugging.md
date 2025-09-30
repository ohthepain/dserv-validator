# Debugging and Service Management

## VPN and local development

VPN is required for local development in order to connect with the Canton Network

## Onboarding secret

If onboarding fails then it's probably an out of date secret. this will happen after db reset
To get an onboarding secret:
curl -X POST $ONBOARDING_SECRET_URL
ONBOARDING_SECRET_URL=https://sv.sv-2.dev.global.canton.network.digitalasset.com/api/sv/v0/devnet/onboard/validator/prepare

## Service Control Commands

- **Start local development**: Use `./go-local.sh` (excludes DAML uploader)
- **Start production**: Use `./go-production.sh` (includes DAML uploader)
- **Stop services**: Use `./stop.sh` (stops all services including DAML uploader)

## Important Notes

- Always use the project's custom scripts instead of direct docker compose commands
- **Local development** (`./go-local.sh`): HTTP only, no SSL certificates, no DAML uploader
- **Production** (`./go-production.sh`): HTTPS with SSL certificates, includes DAML uploader
- The `stop.sh` script ensures clean shutdown and proper cleanup of all services
