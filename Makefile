.PHONY: symbolize substitute dry-symbolize dry-substitute

symbolize:
	bash scripts/symbolize.sh

substitute:
	bash scripts/substitute.sh

dry-symbolize:
	bash scripts/symbolize.sh --dry-run

dry-substitute:
	bash scripts/substitute.sh --dry-run
