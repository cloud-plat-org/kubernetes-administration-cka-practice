#! /bin/bash

kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yml
vim pod.yml # add the volume claim to the pod
k create -f pod.yml 
k get pod nginx
k get pvc
 # BOUND
 
 k get pv
 k get pvc

Press Ctrl-R then + to past in vim.