#!/usr/bin/env bash
# Run every analysis notebook from top to bottom and stop at the first error.
# CI runs this same script on each push: run it before committing.
#
# Usage (from the repository root, with the virtual environment activated):
#   bash scripts/check.sh
set -euo pipefail

cd "$(dirname "$0")/.."

shopt -s nullglob
notebooks=(analysis/*.ipynb)
if [ ${#notebooks[@]} -eq 0 ]; then
  echo "No notebook found in analysis/" >&2
  exit 1
fi

for nb in "${notebooks[@]}"; do
  echo "Running $nb"
  # The executed copy goes to stdout and is thrown away: the notebook on disk is left untouched.
  python -m jupyter nbconvert --to notebook --execute "$nb" --stdout --log-level ERROR > /dev/null
done

echo "OK: ${#notebooks[@]} notebook(s) ran without error."
