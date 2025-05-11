#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/lib.sh" "$@"
# ------------------------------------------------------------------------------
# Lock symbolisation
# ------------------------------------------------------------------------------
LOCK_FILE=".lock/symbolization.lock"
if [[ -f "$LOCK_FILE" ]]; then
  echo -e "${RED}[ERROR] Symbolization lock already exists!${NC}"
  echo -e "${YELLOW}[DETAILS] Created on: $(head -n1 "$LOCK_FILE")${NC}"
  echo -e "${YELLOW}[DETAILS] By PID: $(tail -n1 "$LOCK_FILE")${NC}"
  exit 1
fi
mkdir -p "$(dirname "$LOCK_FILE")"
{ date; echo $$; } > "$LOCK_FILE"
echo -e "${GREEN}[INFO] Symbolization lock acquired.${NC}"

# Clean lock if interrupted
trap 'echo -e "${YELLOW}[WARN] Script interrupted. Removing lock."; rm -f "$LOCK_FILE"; exit 1' INT TERM
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
    echo_green "Symbolizing '$expanded_value' --> \${$symbol} in $file"

    if $is_dry_run; then
      echo_yellow "  [DRY-RUN] sed -i 's|$safe_expanded_value|\${$symbol}|g' $file"
    else
      sed -i "s|$safe_expanded_value|\${$symbol}|g" "$file"
    fi
  done
done
