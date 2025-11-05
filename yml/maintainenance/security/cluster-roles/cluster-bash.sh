#! /bin/bash

# Cluster Roles
# Cluster Roles are used to manage cluster-wide resources.
# Cluster Roles are not bound to a namespace.
# Namespaced:
# - Role
# - RoleBinding
# - Services
# - Secrets
# - ConfigMap
# - Pod
# - Deployment
# - ReplicaSet
# - PVC
# either specify the namespace or default

# Cluster Scoped
# nodes  PV
# clusterroles 
# clusterrolebindings
# certificatesigningrequests
# namespaces

kubectl api-resources --namespaced=false
kubectl api-resources --namespaced=true

kubectl create -f cluster-admin-role.yml






