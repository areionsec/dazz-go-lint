#!/usr/bin/env bash

set -e -o pipefail

SERVICE_NAME="$1"
GRPC_FILE_PATH="$2"
DEFAULT_GRPC_FILE_PATH="./internal/ports/grpc"


if [[ -z "$GRPC_FILE_PATH" ]]; then
   GRPC_FILE_PATH=$DEFAULT_GRPC_FILE_PATH
fi

echo "[+] Installing grpc linter"
go install github.com/areionsec/dazz-grpc-linter@latest

echo "[+] Running grpc linter"
dazz-grpc-linter --serviceName $SERVICE_NAME -grpcPath "./internal/ports/grpc"
if [ $? -ne 0 ]; then
  exit 1
fi

