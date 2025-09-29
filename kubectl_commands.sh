#!/bin/bash

# Get the current context
kubectl config current-context

# Get the list of nodes
kubectl get nodes

# Get the list of pods
kubectl get pods

# Get the list of services


kubectl diff -f https://k8s.io/examples/application/simple_deployment.yaml
kubectl diff -f kubectl diff -f simple_deployment.yml



