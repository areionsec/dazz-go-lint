#!/usr/bin/env bash

set -eu -o pipefail

DEFAULT_CONFIG_FILE_URL="https://raw.githubusercontent.com/areionsec/dazz-go-lint/master/.golangci.yml"
DEFAULT_GOLANGCI_LINT_VERSION=v1.54.2
REMOTE_CONFIG_FILE_URL="$1"
GOLANGCI_LINT_VERSION_STR="$2"
GOLANGCI_LINT_VERSION=$2

if [[ -z "$REMOTE_CONFIG_FILE_URL" ]]; then
   # No custom remote config URL, set to default
   echo "No remote config URL is provided, using: $DEFAULT_CONFIG_FILE_URL"
   REMOTE_CONFIG_FILE_URL=$DEFAULT_CONFIG_FILE_URL
else
  echo "Using provided remote config URL: $REMOTE_CONFIG_FILE_URL"
fi

if [[ -z "$GOLANGCI_LINT_VERSION" ]]; then
   # No custom remote config URL, set to default
   echo "No 'golangci-lint' version is provided, using: $DEFAULT_GOLANGCI_LINT_VERSION"
   GOLANGCI_LINT_VERSION=$DEFAULT_GOLANGCI_LINT_VERSION
   GOLANGCI_LINT_VERSION_STR="$DEFAULT_GOLANGCI_LINT_VERSION"
else
  echo "Using provided golangci-lint version: $GOLANGCI_LINT_VERSION"
fi

if [ "$($(go env GOPATH)/bin/golangci-lint version | awk '{print $4}' )" != $GOLANGCI_LINT_VERSION_STR ]; then
    echo "[+] Installing golangci-lint"
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $GOLANGCI_LINT_VERSION
fi

echo "[+] Running golangci-lint"

curl -H "Authorization: token $GITHUB_TOKEN" -L $REMOTE_CONFIG_FILE_URL -o ".golangci.yml" --fail

$(go env GOPATH)/bin/golangci-lint run -v

echo "[+] Running go mod tidy"

go mod tidy -v
if [ $? -ne 0 ]; then
  exit 2
fi

git diff --exit-code go.* &> /dev/null
if [ $? -ne 0 ]; then
    echo "go.mod or go.sum differs, please re-add it to your commit"
    exit 3
fi
