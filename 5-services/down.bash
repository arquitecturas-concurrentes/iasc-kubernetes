#!/usr/bin/env bash
set -euo pipefail
CLUSTER="iasc-example"
doctl k8s cluster delete ${CLUSTER}