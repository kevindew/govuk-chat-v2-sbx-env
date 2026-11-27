#!/usr/bin/env bash
set -euo pipefail

if [ $# -gt 0 ]; then
  echo "Usage: [AWS_ROLE=role] [AWS_REGION=region] [AWS_EXPIRY_TIME=duration] $0" >&2
  exit 1
fi

SANDBOX="govuk-chat-v2"
AWS_ROLE="${AWS_ROLE:-once-chat-development-admin}"
AWS_REGION="${AWS_REGION:-eu-west-1}"
AWS_EXPIRY_TIME="${AWS_EXPIRY_TIME:-4h}"

copy_aws_credentials() {
  if ! command -v gds >/dev/null 2>&1; then
    echo "The GDS CLI isn't installed. Install it from" >&2
    echo "https://github.com/alphagov/gds-cli and try again." >&2
    return 1
  fi

  echo "Press Enter to accept the default in brackets."
  read -rp "AWS role [$AWS_ROLE]: " answer
  AWS_ROLE="${answer:-$AWS_ROLE}"
  read -rp "AWS region [$AWS_REGION]: " answer
  AWS_REGION="${answer:-$AWS_REGION}"
  read -rp "Expiry time [$AWS_EXPIRY_TIME]: " answer
  AWS_EXPIRY_TIME="${answer:-$AWS_EXPIRY_TIME}"

  echo "Getting AWS credentials for $AWS_ROLE"
  credentials=$(gds aws "$AWS_ROLE" --assume-role-ttl "$AWS_EXPIRY_TIME" -- aws configure export-credentials --format process)

  # The SDKs and CLI read the file each time the credentials expire, so
  # processes already running in the sandbox pick up new ones.
  # shellcheck disable=SC2016 # $HOME and $1 are expanded in the sandbox
  printf '%s\n' "$credentials" |
    sbx exec -i "$SANDBOX" sh -c '
      mkdir -p ~/.aws
      (umask 077 && cat > ~/.aws/credentials.json)
      printf "[default]\nregion = %s\ncredential_process = cat %s/.aws/credentials.json\n" "$1" "$HOME" > ~/.aws/config
    ' sh "$AWS_REGION"

  echo "AWS credentials for $AWS_ROLE are in the sandbox, they expire in $AWS_EXPIRY_TIME ⏳"
}

remove_aws_credentials() {
  sbx exec "$SANDBOX" sh -c 'rm -f ~/.aws/credentials.json ~/.aws/config'
  echo "Removed AWS credentials from the sandbox 🧹"
}

echo "The sandbox can have AWS credentials generated from the GDS CLI. They"
echo "expire within hours, so run scripts/setup-aws-credentials.sh again to refresh them."
echo
printf '⚠️  \033[1mWarning:\033[0m anything in the sandbox, including Claude, can use\n'
echo "these credentials. Never use a production account or a role with access"
echo "to production services."
echo
PS3="Choose an option: "
select _ in "Copy AWS credentials into the sandbox" "Remove AWS credentials from the sandbox" "Skip this step"; do
  case $REPLY in
    1)
      copy_aws_credentials
      break
      ;;
    2)
      remove_aws_credentials
      break
      ;;
    3)
      echo "Skipping AWS credentials"
      break
      ;;
    *) echo "Choose 1, 2 or 3" ;;
  esac
done
