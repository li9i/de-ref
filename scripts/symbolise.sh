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
    echo "Replacing '$hardcoded_value' -> $symbol in $file"
    sed -i "s|$hardcoded_value|$symbol|g" "$file"
  done
done
