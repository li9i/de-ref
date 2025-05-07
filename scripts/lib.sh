#!/bin/bash
set -euo pipefail

PARAM_FILE="params/params.yaml"

# Function: load param details into symbol, expanded_value, files
load_param() {
  local i=$1

  symbol=$(yq eval ".params[$i].symbol" "$PARAM_FILE")
  value=$(yq eval ".params[$i].value" "$PARAM_FILE")
  mode=$(yq eval ".params[$i].mode" "$PARAM_FILE")

  [[ -z "$symbol" ]] && return 1

  # Process value based on mode
  if [[ "$mode" == "env" ]]; then
    eval "expanded_value=\"$value\""
  elif [[ "$mode" == "literal" ]]; then
    expanded_value="$value"
  else
    echo "ERROR: Invalid mode '$mode' for symbol '$symbol'. Use 'env' or 'literal'."
    exit 1
  fi

  files=$(yq eval ".params[$i].files[]" "$PARAM_FILE")
}

# Function: validate required env vars (only for mode=env)
validate_env_vars() {
  local value_string="$1"

  # Find all ${VAR} in value_string
  env_vars=$(grep -oP '\$\{\K[^}]+' <<< "$value_string" || true)

  for var in $env_vars; do
    if [[ -z "${!var:-}" ]]; then
      echo "ERROR: Required environment variable '$var' is not set but used in '$value_string'"
      exit 1
    fi
  done
}

# Escape replacement string for safe use in sed replacement (| delimiter)
escape_sed_replacement() {
  local str="$1"
  printf '%s' "$str" | sed -e 's/[&|]/\\&/g'
}
