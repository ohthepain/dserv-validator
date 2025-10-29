#!/bin/bash
set -e

curl -f http://localhost:2${VALIDATOR_ADMIN_API_PORT}/api/validator/readyz
curl -f http://localhost:3${VALIDATOR_ADMIN_API_PORT}/api/validator/readyz
