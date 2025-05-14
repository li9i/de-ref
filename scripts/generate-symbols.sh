#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

echo "[INFO] Generating hash-based symbols in param file: $PARAM_FILE"

param_count=$(yq eval '.params | length' "$PARAM_FILE")
mapfile -t existing_symbols < <(yq eval '.params[].symbol' "$PARAM_FILE" | grep -v 'null' | grep -v '^$')

generate_hash_symbol() {
  local value="$1"
  local mode="$2"
  local input="${mode}:${value}"
  local hash
  hash=$(printf '%s' "$input" | sha1sum | cut -c1-7)
  echo "$hash"
}

for i in $(seq 0 $((param_count - 1))); do
  current_symbol=$(yq eval ".params[$i].symbol" "$PARAM_FILE")
  value=$(yq eval ".params[$i].value" "$PARAM_FILE")
  mode=$(yq eval ".params[$i].mode" "$PARAM_FILE")

  if [[ -z "$current_symbol" || "$current_symbol" == "null" ]]; then
    candidate=$(generate_hash_symbol "$value" "$mode")

    # Ensure no collision (unlikely, but let's be safe)
    if [[ " ${existing_symbols[*]} " =~ " $candidate " ]]; then
      echo_red "[ERROR] Collision detected for hash $candidate — adjust value or mode to resolve."
      exit 1
    fi

    existing_symbols+=("$candidate")
    echo "[INFO] Param[$i] → Generated symbol $candidate (from $mode:$value)"
    yq eval ".params[$i].symbol = \"$candidate\"" -i "$PARAM_FILE"
  else
    echo "[OK] Param[$i] already has symbol → $current_symbol"
  fi
done

echo_green "Symbols generated successfully."
