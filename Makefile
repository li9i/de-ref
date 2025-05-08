.PHONY: generate-symbols reference dereference dry-reference dry-dereference

generate-symbols:
	PARAM_FILE=$(PARAM_FILE) bash scripts/generate-symbols.sh

reference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/reference.sh

dereference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/dereference.sh

dry-reference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/reference.sh --dry-run

dry-dereference:
	PARAM_FILE=$(PARAM_FILE) bash scripts/dereference.sh --dry-run
