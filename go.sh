#!/bin/bash

# Load environment variables from .env file
# Convert .env format to shell export format
while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
        # Convert .env format to export format
        export "$line"
    fi
done < .env

# Run the start script with environment variables
./start.sh -s "$SPONSOR_SV_URL" -o "$ONBOARDING_SECRET" -p "$PARTY_HINT" -m "$MIGRATION_ID" -w
