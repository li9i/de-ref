.PHONY: validate-paths generate-symbols reference dereference dry-reference dry-dereference unlock

# Step 1
validate-paths:
	PARAM_FILE=params/params.yaml bash scripts/validate-paths.sh

# Step 2
generate-symbols:
	PARAM_FILE=$(PARAM_FILE) bash scripts/generate-symbols.sh

# Step 3
reference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/reference.sh

# Step 4
dereference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/dereference.sh

dry-reference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/reference.sh --dry-run

dry-dereference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/dereference.sh --dry-run

unlock:
	rm -f .lock/symbolization.lock
	@echo "[INFO] Lock manually cleared"
