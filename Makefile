.PHONY: reference dereference dry-reference dry-dereference

reference:
	bash scripts/reference.sh

dereference:
	bash scripts/dereference.sh

dry-reference:
	bash scripts/reference.sh --dry-run

dry-dereference:
	bash scripts/dereference.sh --dry-run
