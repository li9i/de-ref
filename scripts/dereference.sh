#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/lib.sh" "$@"
# ------------------------------------------------------------------------------
# Check if symbolisation has not taken place
# ------------------------------------------------------------------------------
LOCK_FILE=".lock/symbolization.lock"

if [[ ! -f "$LOCK_FILE" ]]; then
  echo -e "${RED}[ERROR] No symbolization lock found. Nothing to substitute/unlock.${NC}"
  exit 1
fi
# ------------------------------------------------------------------------------
param_count=$(yq eval '.params | length' "$PARAM_FILE")

for i in $(seq 0 $((param_count - 1))); do
  if ! load_param "$i"; then
    continue
  fi

  if [[ "$mode" == "env" ]]; then
    validate_env_vars "$value"
  fi

  safe_expanded_value=$(escape_sed_replacement "$expanded_value")

  for file in "${files[@]}"; do
    echo_green "Substituting \${$symbol} --> '$expanded_value' in $file"

    if $is_dry_run; then
      echo_yellow "  [DRY-RUN] sed -i 's|\${$symbol}|$safe_expanded_value|g' $file"
    else
      sed -i "s|\${$symbol}|$safe_expanded_value|g" "$file"
    fi
  done
done
# ------------------------------------------------------------------------------
# Unlock
# ------------------------------------------------------------------------------
rm -f "$LOCK_FILE"
echo -e "${GREEN}[INFO] Symbolization lock released.${NC}"
