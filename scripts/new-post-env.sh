#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <post-slug> [python-version] [extra-packages]"
  echo "Example: $0 kernel-regression-transformer 3.12 'jax equinox'"
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "Error: 'uv' is not installed or not on PATH."
  exit 1
fi

SLUG="$1"
PYTHON_VERSION="${2:-3.12}"
EXTRA_PACKAGES="${3:-}"

ENV_DIR=".venvs/posts/${SLUG}"
KERNEL_NAME="quarto-post-${SLUG}"
DISPLAY_NAME="Quarto Post: ${SLUG}"
PYTHON_BIN="${ENV_DIR}/bin/python"

echo "Creating virtual environment: ${ENV_DIR} (Python ${PYTHON_VERSION})"
uv venv "${ENV_DIR}" --python "${PYTHON_VERSION}"

echo "Installing base Jupyter packages"
uv pip install --python "${PYTHON_BIN}" jupyter ipykernel

if [[ -n "${EXTRA_PACKAGES}" ]]; then
  echo "Installing extra packages: ${EXTRA_PACKAGES}"
  uv pip install --python "${PYTHON_BIN}" ${EXTRA_PACKAGES}
fi

echo "Registering kernel: ${KERNEL_NAME}"
"${PYTHON_BIN}" -m ipykernel install --user --name "${KERNEL_NAME}" --display-name "${DISPLAY_NAME}"

cat <<EOF

Done.
- Environment: ${ENV_DIR}
- Kernel: ${KERNEL_NAME}

Add this to your post front matter:

jupyter: ${KERNEL_NAME}

EOF
