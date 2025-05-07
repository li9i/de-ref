#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

param_count=$(yq eval '.params | length' "$PARAM_FILE")

for i in $(seq 0 $((param_count - 1))); do
  if ! load_param "$i"; then
    continue
  fi

  if [[ "$mode" == "env" ]]; then
    validate_env_vars "$value"
  fi

  for file in $files; do
    safe_expanded_value=$(escape_sed_replacement "$expanded_value")
    echo "Symbolizing '$expanded_value' → \${$symbol} in $file"
    sed -i "s|$safe_expanded_value|\${$symbol}|g" "$file"
  done

done
