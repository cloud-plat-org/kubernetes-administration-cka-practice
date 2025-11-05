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









