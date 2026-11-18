#!/usr/bin/env bash
# Steps to set up the govuk-chat-v2 sbx (Docker Sandboxes) environment.
set -euo pipefail

cd "$(dirname "$0")"

REPO_URL="https://github.com/govuk-once/govuk-chat-v2"
REPO_DIR="govuk-chat-v2"

if [ -d "$REPO_DIR/.git" ]; then
  echo "$REPO_DIR already cloned, skipping"
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

# 2. Create the sandbox from sbxenv.yaml. Network policy and the gateway token
#    come from the kits/gds-llm-gateway mixin and the secrets: block, so no manual
#    sbx policy / sbx secret commands are needed. Kit or secret changes only
#    apply on create: run `sbx env rm` first to pick them up.
if sbx ls 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx govuk-chat-v2; then
  echo "govuk-chat-v2 sandbox already exists, skipping (sbx env rm to recreate)"
else
  sbx env create
fi
