#! /bin/bash

# There are two types of accounts in Kubernetes:
# - User Accounts
# - Service Accounts

# User Accounts are used by humans to interact with the cluster.
# Service Accounts are used by applications to interact with the cluster.

# service accounts have a token that is used to authenticate with the cluster.

kubectl get serviceaccounts
# default service account is created in each namespace.
kubectl describe serviceaccount default
# default service account is used by the pod to interact with the cluster.
kubectl get pod my-kubenetes-dashboard 
#  Service Account: default
#  The service account gets mounted as a projected volume in the pod.
# A projected volume is a dynamic directory that contains the service account token.
# /var/run/secrets/kubernetes.io/serviceaccount
kubectl exec -it my-kubenetes-dashboard -- sh ls -al /var/run/secrets/kubernetes.io/serviceaccount
# -rw-r--r--    1 root     root          1166 Nov  5 12:00 ca.crt
# -rw-r--r--    1 root     root           660 Nov  5 12:00 namespace
# -rw-r--r--    1 root     root           660 Nov  5 12:00 token

# The default service account comes with a lot of limitations.
# If you need more permissions, you can create a custom service account.

kubectl create serviceaccount dashboard-sa
kubectl get serviceaccount
kubectl get serviceaccount dashboard-sa -o yaml
kubectl describe serviceaccount dashboard-sa
kubectl create -f service-account.yml

kubectl create -f pod-definition.yml
kubectl describe pod my-kubenetes-dashboard
# Service Account: dashboard-sa
# The service account gets mounted as a projected volume in the pod.
# /var/run/secrets/kubernetes.io/serviceaccount
kubectl exec -it my-kubenetes-dashboard -- sh ls -al /var/run/secrets/kubernetes.io/serviceaccount
# -rw-r--r--    1 root     root          1166 Nov  5 12:00 ca.crt
# -rw-r--r--    1 root     root           660 Nov  5 12:00 namespace
# -rw-r--r--    1 root     root           660 Nov  5 12:00 token

#kubelet automatically refreshes the token, rotates it every 8 hours?
# if you don't want the service acount mounted as a projected volume, you can set the:
# automateServiceAccountToken to false. (in the pod definition.yml or service-account.yml)
automateServiceAccountToken: false















