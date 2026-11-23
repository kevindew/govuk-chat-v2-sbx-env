#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ -n "${CI:-}" ]; then
  pnpm exec prettier . --check
else
  pnpm exec prettier . --write
fi
