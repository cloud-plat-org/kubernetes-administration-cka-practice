#!/bin/bash
source ~/awx-venv/bin/activate

## kubernetes-CKA-0500-Cluster+Maintenance-v1.2.pdf ##
kube-controller-manager --pod-eviction-timeout=5m0s
kubectl get pods -o wide
kubectl drain node01 --ignore-daemonsets
kubectl uncordon node01
kubectl cordon node01
kubectl get pods -o wide

kubectl get pods -A -o=custom-columns=NODE:.spec.nodeName | sort | uniq -c | sort -n
# node/node01 cordoned
# error: unable to drain node "node01" due to error: cannot delete cannot delete Pods 
# that declare no controller (use --force to override): default/hr-app, continuing 
# command...
kubectl drain node01 --ignore-daemonsets --force










