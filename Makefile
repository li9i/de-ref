SYMBOLISE = scripts/symbolise.sh
SUBSTITUTE = scripts/substitute.sh

.PHONY: symbolise substitute help

help:
	@echo "Usage:"
	@echo "  make symbolise   # Replace hardcoded values → symbols"
	@echo "  make substitute  # Replace symbols → actual values"

symbolise:
	bash $(SYMBOLISE)

substitute:
	bash $(SUBSTITUTE)
