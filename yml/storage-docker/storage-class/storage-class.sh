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

# sc-definition.yml: is googe but there are many more:
# AWSElasticBlockStore
# AzureFile
# AzureDisk
# CephFS
# Cider
# FC
# FlexVolume
# GCEPersistentDisk
# Glusterfs
# iSCSI
# Quobyte
# NFS
# RBD
# VsphereVolume
# PortworxVolume
# ScaleIO
# stoarageOS
# Local

kubectl get storageclass
kubectl get storageclass --no-headers -o custom-columns=":metadata.name" 

 kubectl get storageclass --no-headers -o custom-columns=":metadata.name"
# local-path
# local-storage
# portworx-io-priority-high

kubectl describe storageclass local-path

kubectl describe storageclass local-storage
# Provisioner: kubernetes.io/no-provisioner # no provisioner means static provisioning
kubectl describe storageclass portworx-io-priority-high

kubectl create -f pvc-docs.yml
kubectl get pvc local-pvc


kubectl get pvc local-pvc
k get volumes
kubectl get storageclass
kubectl describe storageclass local-path
k describe pvc local-pvc

# The Storage Class called local-path makes use of 
# VolumeBindingMode set to WaitForFirstConsumer. 
# This will delay the binding and provisioning of a 
# PersistentVolume until a Pod using the PersistentVolumeClaim is created.

 k create -f pod.yml 
 k get pod nginx
 k get pvc
 # BOUND
 




