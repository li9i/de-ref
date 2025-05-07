#!/bin/bash
set -euo pipefail

PARAM_FILE="params/params.yaml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Color helpers
echo_green() { echo -e "${GREEN}$*${NC}"; }
echo_yellow() { echo -e "${YELLOW}$*${NC}"; }
echo_red() { echo -e "${RED}$*${NC}"; }

# Parse --dry-run
is_dry_run=false
if [[ "${1:-}" == "--dry-run" ]]; then
  is_dry_run=true
  echo_yellow "[INFO] Dry-run mode enabled — no files will be modified."
fi

# Escape replacement string for safe use in sed replacement
escape_sed_replacement() {
  local str="$1"
  printf '%s' "$str" | sed -e 's/[&|]/\\&/g'
}

# Expand env vars and tilde
expand_env_vars() {
  local str="$1"
  eval "expanded_str=\"$str\""
  if [[ $expanded_str == ~* ]]; then
    expanded_str="${expanded_str/#\~/$HOME}"
  fi
  echo "$expanded_str"
}

# Load param fields into symbol, expanded_value, files[]
load_param() {
  local i=$1

  symbol=$(yq eval ".params[$i].symbol" "$PARAM_FILE")
  value=$(yq eval ".params[$i].value" "$PARAM_FILE")
  mode=$(yq eval ".params[$i].mode" "$PARAM_FILE")

  [[ -z "$symbol" ]] && return 1

  if [[ "$mode" == "env" ]]; then
    eval "expanded_value=\"$value\""
  elif [[ "$mode" == "literal" ]]; then
    expanded_value="$value"
  else
    echo_red "ERROR: Invalid mode '$mode' for symbol '$symbol'. Use 'env' or 'literal'."
    exit 1
  fi

  # Expand env vars and tilde in files
  raw_files=$(yq eval ".params[$i].files[]" "$PARAM_FILE")
  files=()
  while IFS= read -r raw_file; do
    expanded_file=$(expand_env_vars "$raw_file")
    files+=("$expanded_file")
  done <<< "$raw_files"
}

# Validate env vars in value string (only for mode=env)
validate_env_vars() {
  local value_string="$1"
  env_vars=$(grep -oP '\$\{\K[^}]+' <<< "$value_string" || true)
  for var in $env_vars; do
    if [[ -z "${!var:-}" ]]; then
      echo_red "ERROR: Required env var '$var' not set but used in '$value_string'"
      exit 1
    fi
  done
}
