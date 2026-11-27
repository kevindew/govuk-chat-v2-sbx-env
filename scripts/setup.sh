#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

REPO_URL="https://github.com/govuk-once/govuk-chat-v2"
REPO_DIR="govuk-chat-v2"

if [ -d "$REPO_DIR/.git" ]; then
  echo "$REPO_DIR already cloned, skipping"
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

GITHUB_TOKEN_KEYCHAIN_ITEM="govuk-chat-v2-sbx-github"
GITHUB_TOKEN_URL="https://github.com/settings/personal-access-tokens/new?name=govuk-chat-v2+sandbox&description=Used+by+the+govuk-chat-v2+Docker+sandbox&target_name=govuk-once&expires_in=30&contents=write&pull_requests=write"

stored_github_token() {
  security find-generic-password -s "$GITHUB_TOKEN_KEYCHAIN_ITEM" -w 2>/dev/null
}

# Passing the header on stdin keeps the token out of the process list.
github_token_works() {
  printf 'Authorization: Bearer %s\n' "$1" |
    curl -fs -o /dev/null -H @- https://api.github.com/user
}

store_github_token() {
  echo "Paste the token below to store it in your Keychain."
  security add-generic-password -U -s "$GITHUB_TOKEN_KEYCHAIN_ITEM" -a "$USER" -w

  if ! github_token_works "$(stored_github_token)"; then
    security delete-generic-password -s "$GITHUB_TOKEN_KEYCHAIN_ITEM" >/dev/null
    echo "GitHub didn't accept that token 😩. Check you copied all of it and try again." >&2
    return 1
  fi

  echo "GitHub token works and is in your Keychain 🪄"
}

if github_token=$(stored_github_token) && github_token_works "$github_token"; then
  echo "Confirmed that the GitHub token in Keychain works ☺️"
else
  echo "The sandbox needs a GitHub token to install private dependencies,"
  echo "push branches and open pull requests."
  PS3="Choose an option: "
  select _ in "Help me create one" "Paste in a token" "Skip this step"; do
    case $REPLY in
      1)
        echo "GitHub's token form will be filled in apart from the repositories:"
        echo "select govuk-chat-v2 and govuk-chat-v2-private."
        read -rp "Press Enter to open it in your browser. "
        open "$GITHUB_TOKEN_URL"
        store_github_token && break
        ;;
      2)
        store_github_token && break
        ;;
      3)
        echo "Skipping the GitHub token"
        break
        ;;
      *) echo "Choose 1, 2 or 3" ;;
    esac
  done
fi

if sbx ls 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx govuk-chat-v2; then
  echo "govuk-chat-v2 sandbox already exists, skipping (sbx env rm to recreate)"
else
  sbx env create
fi
