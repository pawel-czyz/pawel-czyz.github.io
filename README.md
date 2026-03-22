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
- The default template [`_post_template.qmd`](_post_template.qmd) sets `draft: true`. Remove it only when publishing.

## uv Environments and Per-Post Kernels

Use one default `uv` environment for most posts and optional dedicated environments for selected posts.

Default environment:

1. Create/sync default environment (example):
   `uv venv && uv sync`
2. Register default kernel:
   `make default-kernel`
3. In posts that should use default environment, set:

```yaml
jupyter: quarto-default
```

Per-post environment:

```bash
make post-env POST=<slug> [PYTHON=3.12] [PACKAGES='pkg1 pkg2']
```

Examples:

```bash
make post-env POST=kernel-regression-transformer
make post-env POST=kernel-regression-transformer PYTHON=3.12 PACKAGES='jax equinox'
```

This creates `.venvs/posts/<slug>`, installs `jupyter` and `ipykernel` (plus optional packages), and registers kernel:

`quarto-post-<slug>`

Then set in that post front matter:

```yaml
jupyter: quarto-post-<slug>
```

Helper script:
- [`scripts/new-post-env.sh`](scripts/new-post-env.sh)

## Blog Listing Hygiene

- If a dead row appears in blog listing/search (for example placeholder `TITLE` / `DESCRIPTION`), regenerate listing artifacts:

```bash
quarto render blog.qmd
```

- This updates `docs/blog.html`, `docs/listings.json`, `docs/search.json`, and `docs/sitemap.xml` without recomputing all analyses.
