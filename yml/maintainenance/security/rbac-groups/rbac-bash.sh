#! /bin/bash

kubectl create -f rbac-role-developer.yml
# next step is to link a user to the role
kubectl create -f devuser-developer-binding.yml
# must specify the namespace in metadata if other than default
kubectl get roles -n default
kubectl get rolebindings -n default
kubectl describe role developer -n default
kubectl describe rolebinding devuser-developer-binding -n default
kubectl delete role developer -n default
kubectl delete rolebinding devuser-developer-binding -n default

# how do I check my access?
kubectl auth can-i create roles -n default
kubectl auth can-i create rolebindings -n default
# if administrator, you can check a user's access to a resource
kubectl auth can-i create pods -n default --as=dev-user
# if yes, it shows dev-user can create pods in the default namespace
# if no, it shows dev-user cannot create pods in the default namespace

k describe pod kube-apiserver-controlplane -n kube-system
#  --authorization-mode=Node,RBAC
k get roles -A
k bet roles -n default
# what are the resources available in the kube-proxy role?
k describe role kube-proxy -n kube-system
# Name:         kube-proxy
# Labels:       <none>
# Annotations:  <none>
# PolicyRule:
#   Resources   Non-Resource URLs  Resource Names  Verbs
#   ---------   -----------------  --------------  -----
#   configmaps  []                 [kube-proxy]    [get]
## kube-porxy role can only get configmaps with the name kube-proxy

 k describe rolebinding kube-proxy -n kube-system
# Name:         kube-proxy
# Labels:       <none>
# Annotations:  <none>
# Role:
#   Kind:  Role
#   Name:  kube-proxy
# Subjects:
#   Kind   Name                                             Namespace
#   ----   ----                                             ---------
#   Group  system:bootstrappers:kubeadm:default-node-token 
# account assigned to the kube-proxy role: system:bootstrappers:kubeadm:default-node-token














