#!/usr/bin/env bash
set -euo pipefail
CLUSTER="iasc-example"
SERVICE="iasc-service-example"
CONTEXT="do-nyc1-${CLUSTER}"
doctl k8s cluster create ${CLUSTER}
kubectl --context ${CONTEXT} apply -f iasc-service-complete.yaml
script/wait-for-service ${CONTEXT} ${SERVICE}
open http://$(kubectl --context ${CONTEXT} get service ${SERVICE} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")