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

kubectl create -f cluster-admin-rolebinding.yml 

# Cluser roles can be used for namespace scoped resources as well.

 k get clusterroles --no-headers | wc -l

 k get clusterrolebindings --no-headers | wc -l

k create clusterrole view-nodes --resource=nodes --verb=get,list,watch
k describe clusterrole view-nodes

k create clusterrolebinding view-nodes-binding --clusterrole=view-nodes --user=michelle
k describe clusterrolebinding view-nodes-binding

kubectl api-resources --namespaced=false

PersistentVolume
StorageClass
VolumeAttachment
VolumeAttributesClass
k create clusterrole storage-admin --resource=storageclasses,persistentvolumes --verb=get,list,watch,create,update,delete
k describe clusterrole storage-admin

k create clusterrolebinding michelle-storage-admin --clusterrole=storage-admin --user=michelle
k describe clusterrolebinding michelle-storage-admin





