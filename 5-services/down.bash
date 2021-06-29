#!/usr/bin/env bash
set -euo pipefail
CLUSTER="iasc-example"
doctl compute load-balancer delete --force $(kubectl get svc iasc-example -o jsonpath="{.metadata.annotations.kubernetes\.digitalocean\.com/load-balancer-id}")
doctl k8s cluster delete ${CLUSTER}