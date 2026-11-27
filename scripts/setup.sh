#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

REPO_URL="https://github.com/govuk-once/govuk-chat-v2"
REPO_DIR="govuk-chat-v2"

echo "== Cloning govuk-chat-v2"
if [ -d "$REPO_DIR/.git" ]; then
  echo "$REPO_DIR already cloned, skipping"
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

echo "== Setting up GitHub Token"
scripts/setup-github-token.sh

echo "== Setting up CDK GitHub Token"
scripts/setup-cdk-github-token.sh

echo "== Setting up GitHub signing key"
scripts/setup-github-signing-key.sh

echo "== Creating the sandbox"
if sbx ls 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx govuk-chat-v2; then
  echo "govuk-chat-v2 sandbox already exists, skipping (sbx env rm to recreate)"
else
  sbx env create
fi

echo "== Setting up AWS credentials"
scripts/setup-aws-credentials.sh
