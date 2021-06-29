#!/usr/bin/env bash
set -euo pipefail
TARGET="iascfrba/nginx-example"
docker build -t ${TARGET} .
docker push ${TARGET}