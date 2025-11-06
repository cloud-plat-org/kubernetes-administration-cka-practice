#! /bin/bash

# Network Policies

# Traffic

user -> web-app (port 80) -> api-server (port 5000) -> database (port 3306)
  # ingress traffic user to web-app     # egress traffic web-app to api-server
  # ingress traffic api-server to database     # egress traffic api-server to database

# Create rules to allow traffic between pods.
1. ingress port 80 to web-app
2. egress port 5000 to web-app
3. ingress port 5000 to api-server
4. egress port 3306 to api-server
5. ingress port 3306 to database

Network Security:
# each pod, service, and node has it's own IP address.
# "all allow" is the default policy for pods and services with the cluster.
#  In the case above we would replace all the servers with pods and services so they can communicate with each other.
# what if we don't want the web-app pod to communicate with the database pod?
# create a network policy (its own entity) and link it to one or more of the pods.
# Network policies are applied at the pod level, not at the node level.
# on the database pod we would create a network policy to only allow traffic on port 3306 from the api-server pod.
# This would block all other traffic to the database pod.

kubectl create -f db-network-policy.yml
kubectl get networkpolicies
kubectl describe networkpolicy db-network-policy
kubectl delete networkpolicy db-network-policy

# NOTE: Network policies are enforced by the network solution provider running on the cluster.
# Solutions that support network policies:
# - Kube-router
# - Calico
# - Romana
# Solutions that do not support network policies:
# - Flannel

https://kubernetes.io/docs/concepts/services-networking/network-policies/

