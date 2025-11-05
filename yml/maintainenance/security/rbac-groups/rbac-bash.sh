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
#  --authorization-mode=Node,RBAC'
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization-mode
ps aux | grep kube-apiserver | grep authorization-mode

k get roles -A
k get roles -A --no-headers | wc -l
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

k auth can-i list pods -n default --as=dev-user
# no, it shows dev-user cannot list pods in the default namespace
k get pods -n default --as=dev-user

 kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods
 # https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_role/
kubectl create role pod-reader --verb=get,list,watch --resource=pods
k describe role pod-reader
# Role: developer
# Role Resources: pods
# Role Actions: list
# Role Actions: create
# Role Actions: delete
# RoleBinding: dev-user-binding
# RoleBinding: Bound to dev-user
kubectl create role developer --verb=list,create,delete --resource=pods -n default
kubectl create rolebinding dev-user-binding --role=developer --user=dev-user -n default
k describe role developer -n default
k describe rolebinding dev-user-binding -n default

kubectl get pod dark-blue-app -n blue --as=dev-user
# no, it shows dev-user cannot get pod dark-blue-app in the blue namespace
kubectl create role developer --verb=get,watch,create,delete --resource=pods --resource-name=dark-blue-app -n blue
k describe role developer -n blue

k edit role developer -n blue # wq! to save and exit
k replace -f /tmp/kubectl-edit-developer.yaml --force
vim /tmp/kubectl-edit-developer.yaml
k describe rolebinding dev-user-binding -n blue

k create deployment nginx-deploy --image=nginx --replicas=2 -n blue --as=dev-user
# no, it shows dev-user cannot create deployment nginx-deploy in the blue namespace
k edit role developer -n blue
# apiGroups: ["apps"]






