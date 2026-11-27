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

SIGNING_KEY="$HOME/.ssh/govuk-chat-v2-sbx-signing"
SIGNING_KEY_TITLE="govuk-chat-v2 sandbox"

if ! $reset && [ -f "$SIGNING_KEY" ]; then
  echo "Sandbox signing key already exists at $SIGNING_KEY ☺️"
  exit 0
fi

add_signing_key_with_gh() {
  if ! gh auth status >/dev/null 2>&1; then
    echo "The GitHub CLI isn't installed or signed in. Set it up with" >&2
    echo "https://cli.github.com and \`gh auth login\`, or choose another option." >&2
    return 1
  fi

  if ! gh auth status 2>&1 | grep -q "admin:ssh_signing_key"; then
    echo "The GitHub CLI needs permission to manage your SSH signing keys."
    gh auth refresh -h github.com -s admin:ssh_signing_key
  fi

  gh api --paginate user/ssh_signing_keys \
    --jq ".[] | select(.title == \"$SIGNING_KEY_TITLE\") | .id" |
    while read -r id; do
      gh api -X DELETE "user/ssh_signing_keys/$id"
    done

  gh ssh-key add "$SIGNING_KEY.pub" --type signing --title "$SIGNING_KEY_TITLE"
  echo "Sandbox signing key added to GitHub 🪄"
}

add_signing_key_by_hand() {
  pbcopy <"$SIGNING_KEY.pub"
  echo "Copied the public key to your clipboard. On GitHub, choose"
  echo "\"Signing Key\" as the key type and paste it in."
  if $reset; then
    echo "Then delete the old \"$SIGNING_KEY_TITLE\" signing key."
  fi
  read -rp "Press Enter to open GitHub's new SSH key page in your browser. "
  open "https://github.com/settings/ssh/new"
}

echo "Creating an SSH key for the sandbox to sign commits with, so they show"
echo "as verified on GitHub. Your own signing key stays on this machine."
mkdir -p "$HOME/.ssh"
rm -f "$SIGNING_KEY" "$SIGNING_KEY.pub"
# No passphrase, as the sandbox signs commits without anyone to type one.
ssh-keygen -q -t ed25519 -N "" -C "$SIGNING_KEY_TITLE" -f "$SIGNING_KEY"

echo "Now the public key needs adding to your GitHub account."
PS3="Choose an option: "
select _ in "Add it for me with the GitHub CLI" "I'll add it myself"; do
  case $REPLY in
    1) add_signing_key_with_gh && break ;;
    2)
      add_signing_key_by_hand
      break
      ;;
    *) echo "Choose 1 or 2" ;;
  esac
done
