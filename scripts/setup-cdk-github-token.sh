#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  "") reset=false ;;
  --reset) reset=true ;;
  *)
    echo "Usage: $0 [--reset]" >&2
    exit 1
    ;;
esac

CDK_GITHUB_TOKEN_KEYCHAIN_ITEM="govuk-chat-v2-sbx-cdk-github"
CDK_GITHUB_TOKEN_URL="https://github.com/settings/personal-access-tokens/new?name=govuk-chat-v2+sandbox+CDK&description=Used+by+CDK+bundling+in+the+govuk-chat-v2+Docker+sandbox&target_name=govuk-once&expires_in=30&contents=read"

stored_cdk_github_token() {
  security find-generic-password -s "$CDK_GITHUB_TOKEN_KEYCHAIN_ITEM" -w 2>/dev/null
}

# Passing the header on stdin keeps the token out of the process list.
cdk_github_token_works() {
  printf 'Authorization: Bearer %s\n' "$1" |
    curl -fs -o /dev/null -H @- https://api.github.com/user
}

store_cdk_github_token() {
  echo "Paste the token below to store it in your Keychain."
  security add-generic-password -U -s "$CDK_GITHUB_TOKEN_KEYCHAIN_ITEM" -a "$USER" -w

  if ! cdk_github_token_works "$(stored_cdk_github_token)"; then
    security delete-generic-password -s "$CDK_GITHUB_TOKEN_KEYCHAIN_ITEM" >/dev/null
    echo "GitHub didn't accept that token 😬. Check you copied all of it and try again." >&2
    return 1
  fi

  echo "CDK GitHub token works and is in your Keychain ✨"
}

if ! $reset && cdk_github_token=$(stored_cdk_github_token) && cdk_github_token_works "$cdk_github_token"; then
  echo "Confirmed that the CDK GitHub token in Keychain works 👍"
else
  echo "CDK synth in the sandbox needs its own GitHub token to install the"
  echo "private govuk-chat-v2-private dependency. The sandbox can read this"
  echo "token, so it should only have read access to that one repository."
  echo "You can skip this if you won't run CDK synth in the sandbox."
  PS3="Choose an option: "
  select _ in "Help me create one" "Paste in a token" "Skip this step"; do
    case $REPLY in
      1)
        echo "GitHub's token form will be filled in apart from the repositories:"
        echo "select govuk-chat-v2-private only."
        read -rp "Press Enter to open it in your browser. "
        open "$CDK_GITHUB_TOKEN_URL"
        store_cdk_github_token && break
        ;;
      2)
        store_cdk_github_token && break
        ;;
      3)
        echo "Skipping the CDK GitHub token"
        break
        ;;
      *) echo "Choose 1, 2 or 3" ;;
    esac
  done
fi
