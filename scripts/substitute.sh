#!/bin/bash
set -euo pipefail

PARAM_FILE="params/symbolise.yaml"

param_count=$(yq eval '.params | length' "$PARAM_FILE")

for i in $(seq 0 $((param_count - 1))); do
  symbol=$(yq eval ".params[$i].symbol" "$PARAM_FILE")
  hardcoded_value=$(yq eval ".params[$i].hardcoded_value" "$PARAM_FILE")

  [[ -z "$symbol" ]] && continue

  files=$(yq eval ".params[$i].files[]" "$PARAM_FILE")
  for file in $files; do
    safe_expanded_value=$(escape_sed_replacement "$expanded_value")
    echo "Substituting \${$symbol} → '$expanded_value' in $file"
    sed -i "s|\${$symbol}|$safe_expanded_value|g" "$file"
  done

done
