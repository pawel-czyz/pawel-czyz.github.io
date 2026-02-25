# Quarto Blog Workflow

This blog is built with Quarto and published to GitHub Pages.

## Key Configuration

- Quarto project config: [`_quarto.yml`](_quarto.yml)
- Output directory for published site: `docs/`
- Execution policy:
  - `freeze: true` (do not re-run code unless explicitly requested)
  - `cache: true` (reuse cached results when execution is requested)

## Local Commands

Use the [`Makefile`](Makefile):

```bash
make typo
```

- Fast render for text/typo/layout changes.
- Equivalent to `quarto render`.
- Does not execute code cells due to global freeze.

```bash
make post POST=<slug>
```

- Recompute one post and update outputs.
- Example: `make post POST=board-games-monte-carlo`
- Equivalent to `quarto render posts/<slug>.qmd --execute`.

```bash
make full
```

- Recompute the whole website.
- Equivalent to `quarto render --execute`.

```bash
make preview
```

- Start local preview server.

## Deploy

GitHub Actions workflow:
- [`.github/workflows/quarto-pages.yml`](.github/workflows/quarto-pages.yml)

It runs on push to `main` (or manual trigger), renders the site, and deploys Pages from `docs/`.

## Typical Daily Flow

1. Edit content.
2. Run `make typo` for normal text/site changes.
3. If you changed analysis/code outputs, run `make post POST=<slug>` (or `make full`).
4. Commit and push.

## Drafts

- Keep unfinished posts in `_drafts/` (or set `draft: true` in front matter) so they are not published from `posts/`.
