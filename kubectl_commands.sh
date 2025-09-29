#!/bin/bash

kubectl apply -f simple_deployment.yml dry-run=client -o yaml

# Get the current context
kubectl config current-context
    #minikube
# Get the list of namespaces
kubectl get namespaces

# Get the list of nodes
kubectl get nodes --all-namespaces

# Get the list of pods
kubectl get pods --all-namespaces

# Get the list of services
kubectl get services --all-namespaces

# Get the list of deployments
kubectl get deployments --all-namespaces

# Get the list of replicasets
kubectl get replicasets --all-namespaces

# Get the list of jobs
kubectl get jobs --all-namespaces

# Get the list of cronjobs
kubectl get cronjobs --all-namespaces

# Get the list of statefulsets
kubectl get statefulsets --all-namespaces

# Get the list of daemonsets
kubectl get daemonsets --all-namespaces

# Get the list of configmaps
kubectl get configmaps --all-namespaces

# Get the list of secrets
kubectl get secrets --all-namespaces

# Get the list of persistentvolumes
kubectl get persistentvolumes --all-namespaces

# Get the list of persistentvolumeclaims
kubectl get persistentvolumeclaims --all-namespaces

# Get the list of nodes
kubectl get nodes --all-namespaces

# Get the list of events
kubectl get events --all-namespaces

# Get the list of componentstatuses
kubectl get componentstatuses --all-namespaces

# Get the list of limitranges
kubectl get limitranges --all-namespaces

# Get the list of resourcequotas
kubectl get resourcequotas --all-namespaces 

kubectl diff -f https://k8s.io/examples/application/simple_deployment.yaml
kubectl diff -f kubectl diff -f simple_deployment.yml



