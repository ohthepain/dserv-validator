#!/usr/bin/env bash
# Wrapper entrypoint to ensure per-backend onboarding secrets are available.

set -eo pipefail

fetch_secret() {
  local var_name="$1"
  local secret_value

  if [[ -z "${ONBOARDING_SECRET_URL:-}" ]]; then
    echo "ONBOARDING_SECRET_URL is not set; cannot fetch ${var_name}." >&2
    return 1
  fi

  echo "Fetching ${var_name} from ${ONBOARDING_SECRET_URL}..."
  if ! secret_value="$(curl -sfL -X POST "${ONBOARDING_SECRET_URL}" )"; then
    echo "Failed to fetch ${var_name} from ${ONBOARDING_SECRET_URL}." >&2
    return 1
  fi

  export "${var_name}=${secret_value}"
}

if [[ -z "${APP_USER_VALIDATOR_ONBOARDING_SECRET:-}" ]]; then
  fetch_secret APP_USER_VALIDATOR_ONBOARDING_SECRET
fi

if [[ -z "${APP_PROVIDER_VALIDATOR_ONBOARDING_SECRET:-}" ]]; then
  fetch_secret APP_PROVIDER_VALIDATOR_ONBOARDING_SECRET
fi

exec /app/entrypoint.sh "$@"


