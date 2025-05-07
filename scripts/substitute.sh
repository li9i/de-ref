#!/bin/bash
set -euo pipefail

PARAM_FILE="params/substitute.yaml"

param_count=$(yq eval '.params | length' "$PARAM_FILE")

for i in $(seq 0 $((param_count - 1))); do
  symbol=$(yq eval ".params[$i].symbol" "$PARAM_FILE")
  value=$(yq eval ".params[$i].value" "$PARAM_FILE")
  mode=$(yq eval ".params[$i].mode" "$PARAM_FILE")

  [[ -z "$symbol" ]] && continue

  # Determine how to process value
  if [[ "$mode" == "env" ]]; then
    eval "expanded_value=\"$value\""
  elif [[ "$mode" == "literal" ]]; then
    expanded_value="$value"
  else
    echo "ERROR: Invalid mode '$mode' for symbol '$symbol'. Use 'env' or 'literal'."
    exit 1
  fi

  files=$(yq eval ".params[$i].files[]" "$PARAM_FILE")
  for file in $files; do
    echo "Substituting $symbol -> '$expanded_value' in $file"
    sed -i "s|$symbol|$expanded_value|g" "$file"
  done
done
