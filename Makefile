QUARTO ?= quarto

PYTHON ?= 3.12
POST ?=
PACKAGES ?=

.PHONY: help typo render post full preview post-env default-kernel

help:
	@echo "Usage:"
	@echo "  make typo                # Fast render without executing code"
	@echo "  make post POST=<path>    # Recompute one post (e.g. POST=posts/board-games-monte-carlo.qmd)"
	@echo "  make full                # Recompute the whole site"
	@echo "  make preview             # Local preview server"
	@echo "  make default-kernel      # Register default .venv kernel as quarto-default"
	@echo "  make post-env POST=<slug> [PYTHON=3.12] [PACKAGES='pkg1 pkg2']"

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

default-kernel:
	.venv/bin/python -m ipykernel install --user --name quarto-default --display-name "Quarto Default (uv)"

post-env:
ifndef POST
	$(error POST is required. Example: make post-env POST=kernel-regression-transformer)
endif
	./scripts/new-post-env.sh "$(POST)" "$(PYTHON)" "$(PACKAGES)"
