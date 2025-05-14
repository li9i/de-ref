#!/bin/bash
set -euo pipefail

# Load color helpers
source "$(dirname "$0")/lib.sh"

PARAM_FILE="${PARAM_FILE:-params/params.yaml}"

echo "Validating file $PARAM_FILE..."

missing_paths=0

# Get total param entries
param_count=$(yq eval '.params | length' "$PARAM_FILE")

for i in $(seq 0 $((param_count - 1))); do
  path_count=$(yq eval ".params[$i].files | length" "$PARAM_FILE")

  for j in $(seq 0 $((path_count - 1))); do
    raw_path=$(yq eval ".params[$i].files[$j]" "$PARAM_FILE")
    expanded_path=$(eval echo "$raw_path")

    if [[ ! -e "$expanded_path" ]]; then
      # Find the line number in the YAML file for reporting
      line_number=$(grep -n "$raw_path" "$PARAM_FILE" | cut -d: -f1 | head -n1)
      echo_red "[ERROR] File not found: $expanded_path"
      echo     "        declared at $PARAM_FILE:L$line_number"
      ((missing_paths++))
    fi
  done
done

echo "Validation ended"
if [[ "$missing_paths" -gt 0 ]]; then
  echo_red "[FAIL] $missing_paths missing file(s) detected. Aborting."
  exit 1
else
  echo_green "All declared files exist. Exiting..."
fi
