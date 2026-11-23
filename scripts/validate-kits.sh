#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Each kit's syntax line makes BuildKit build it with Docker's kit builder,
# which fails on an invalid kit.
for kit in kits/*/; do
  name=$(basename "$kit")
  docker buildx build -f "$kit$name.yaml" -o type=cacheonly "$kit"
done
