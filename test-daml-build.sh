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
daml_dir="${script_dir}/../deserve/daml"

_info "Testing DAML package build..."

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

# Check if daml command is available
if ! command -v daml &> /dev/null; then
  _error_msg "DAML SDK is not installed or not in PATH"
  _info "Please install DAML SDK from https://docs.daml.com/getting-started/installation.html"
  exit 1
fi

# Check DAML project structure
_info "Checking DAML project structure..."
if [ ! -f "${daml_dir}/daml.yaml" ]; then
  _error_msg "daml.yaml not found in ${daml_dir}"
  exit 1
fi

# Build the DAML package
_info "Building DAML package..."
if ! daml build; then
  _error_msg "Failed to build DAML package"
  exit 1
fi

# Check if the DAR file was created
dar_file=".daml/dist/asset-transfer-1.0.0.dar"
if [ ! -f "${dar_file}" ]; then
  _error_msg "DAR file not found at ${dar_file}"
  exit 1
fi

_info "DAML package built successfully!"
_info "DAR file created: ${dar_file}"
_info "Package size: $(du -h "${dar_file}" | cut -f1)"

# List package contents
_info "Package contents:"
daml damlc inspect-dar "${dar_file}" | head -20
