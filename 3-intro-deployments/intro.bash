#!/bin/bash

kubectl create deployment simplest-deployment --image=k8s.gcr.io/echoserver:1.4

kubectl expose deployment simplest-deployment --type=NodePort --port=8080

kubectl get pods

kubectl get po simplest-deployment-55665bfc59-drjd5 -o yaml

kubectl get services simplest-deployment

kubectl port-forward service/simplest-deployment 7080:8080
