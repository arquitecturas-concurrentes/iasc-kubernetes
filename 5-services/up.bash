#!/usr/bin/env bash
set -euo pipefail
CLUSTER="iasc-example"
SERVICE="iasc-service-example"
CONTEXT="do-nyc1-${CLUSTER}"
doctl k8s cluster create ${CLUSTER}
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml
kubectl --context ${CONTEXT} apply -f iasc-service-complete.yaml
./scripts/wait-for-service ${CONTEXT} ${SERVICE}
open http://$(kubectl --context ${CONTEXT} get service ${SERVICE} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
