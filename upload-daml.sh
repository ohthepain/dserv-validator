#!/usr/bin/env bash

# Copyright (c) 2024 Digital Asset (Switzerland) GmbH and/or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

# issue a user friendly green informational message
function _info(){
  local first_line="INFO: "
  while read -r; do
    printf -- "\e[32;1m%s%s\e[0m\n" "${first_line:-     }" "${REPLY}"
    unset first_line
  done < <(echo -e "$@")
}

# issue a user friendly red error
function _error_msg(){
  # shellcheck disable=SC2145
  echo -e "\e[1;31mERROR: $@\e[0m" >&2
}

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Use the mounted daml directory directly (mounted at /daml in container)
daml_dir="/daml"

_info "Starting DAML package upload process..."

# Check if DAML directory exists
if [ ! -d "${daml_dir}" ]; then
  _error_msg "DAML directory not found at ${daml_dir}"
  exit 1
fi

# Check if daml.yaml exists
if [ ! -f "${daml_dir}/daml.yaml" ]; then
  _error_msg "daml.yaml not found in ${daml_dir}"
  exit 1
fi

# Change to DAML directory
cd "${daml_dir}"

# Build the DAML package
_info "Building DAML package..."
if ! daml build; then
  _error_msg "Failed to build DAML package"
  exit 1
fi

# Wait for participant to be ready
_info "Waiting for participant to be ready..."
max_attempts=30
attempt=1
while [ $attempt -le $max_attempts ]; do
  if curl -s -f "http://participant:5011/health" > /dev/null 2>&1; then
    _info "Participant is ready"
    break
  fi
  
  if [ $attempt -eq $max_attempts ]; then
    _error_msg "Participant did not become ready within expected time"
    exit 1
  fi
  
  _info "Participant not ready yet, retrying in 10 seconds (attempt $attempt/$max_attempts)"
  sleep 10
  attempt=$((attempt + 1))
done

# Upload the DAML package
_info "Uploading DAML package to participant..."
if ! daml ledger upload-dar --host participant --port 5011 .daml/dist/asset-transfer-1.0.0.dar; then
  _error_msg "Failed to upload DAML package to participant"
  exit 1
fi

_info "DAML package uploaded successfully!"
