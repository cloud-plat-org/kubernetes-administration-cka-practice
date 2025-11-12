#! /bin/bash

### Storage Classes ###

# PV to PVC binding # requirments:
# sufficient capacity   *****
# access modes          *****
# storage class         ***** 
# volume mode           ***** 
# selectors             ***** 

# When using cloud storage, the storage needs to be created 
# before the PV can be created.

### Static Provisioning ###

# This is where storage classes are used to provision the storage.

kubectl create -f sc-definition.yml
kubectl create -f pvc-sc-definition.yml
kubectl create -f pod-definition.yml

kubectl get pv
kubectl get pvc
kubectl get pod

kubectl describe pod random-number-generator
kubectl describe pvc myclaim
kubectl describe sc google-storage





















