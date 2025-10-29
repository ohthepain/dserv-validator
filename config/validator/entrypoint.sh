#!/usr/bin/env bash
# Wrapper entrypoint to ensure per-backend onboarding secrets are available.

set -eo pipefail

# fetch onboarding secret from super-validator if none is provided. Only works in LocalNet and DevNet
if [[ -z "${APP_PROVIDER_VALIDATOR_ONBOARDING_SECRET:-}" ]]; then
    echo "No provider onboarding secret provided. Attempting to fetch from super-validator via $ONBOARDING_SECRET_URL..."
    export APP_PROVIDER_VALIDATOR_ONBOARDING_SECRET="$(curl -sfL -X POST "$ONBOARDING_SECRET_URL")"
    echo "Fetched provider onboarding secret: $APP_PROVIDER_VALIDATOR_ONBOARDING_SECRET"
fi

if [[ -z "${APP_USER_VALIDATOR_ONBOARDING_SECRET:-}" ]]; then
    echo "No user onboarding secret provided. Attempting to fetch from super-validator via $ONBOARDING_SECRET_URL..."
    export APP_USER_VALIDATOR_ONBOARDING_SECRET="$(curl -sfL -X POST "$ONBOARDING_SECRET_URL")"
    echo "Fetched user onboarding secret: $APP_USER_VALIDATOR_ONBOARDING_SECRET"
fi

exec /app/entrypoint.sh "$@"


