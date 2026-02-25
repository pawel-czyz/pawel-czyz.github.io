QUARTO ?= quarto

.PHONY: help typo render post full preview

help:
	@echo "Usage:"
	@echo "  make typo                # Fast render without executing code"
	@echo "  make post POST=<slug>    # Recompute a single post (e.g. POST=board-games-monte-carlo)"
	@echo "  make full                # Recompute the whole site"
	@echo "  make preview             # Local preview server"

typo render:
	$(QUARTO) render

post:
ifndef POST
	$(error POST is required. Example: make post POST=posts/board-games-monte-carlo.qmd)
endif
	$(QUARTO) render $POST --execute

full:
	$(QUARTO) render --execute

preview:
	$(QUARTO) preview
