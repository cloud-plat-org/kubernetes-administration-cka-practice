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

# Creete a token for use of the service account.
kubectl create token dashboard-sa
# shares it on screen, by default it is 1 hour
kubectl create token dashboard-sa --duration=8h

jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <(kubectl create token dashboard-sa)
jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< X8fwalis..... # token

curl https://192.168.49.70:6443/api -insecure -H "Authorization: Bearer X8fwalis....."

# every namespace has a default service account.
# the default namespace is used for pods create within the namespace.
# if you want to attach a service account to a pod use the serviceAccountName field in the pod definition.yml
# When serviceAccountName is specified:
#   automatically mount the service account token to the pod.
#   automatically rotates the token
#   automatically expires the token when the pod is deleted.

k get serviceaccount default -o wide
# no token is created for the default service account.
# pods is forbidden: User "system:serviceaccount:default:default" 
#cannot list resource "pods" in API group "" in the namespace "default"
k describe serviceaccount default
# Tokens: none

k describe pod web-dashboard-7666579d69-2sh22 | grep Service\ Account
# Service Account:  default
#     Mounts:
#       /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-n5d5
k describe pod web-dashboard-7666579d69-2sh22 
# Image: 

kubectl create serviceaccount dashboard-sa 
# after rbac permissions were added to the service account, a token is created for the service account.
# ls /var/rbac
# dashboard-sa-role-binding.yaml  pod-reader-role.yaml

kubectl create token dashboard-sa
# past token into dashboard web ui.

kubectl get deployment web-dashboard -o yaml > deployment-def.yml
# vim deployment-def.yml
# change serviceAccountName to dashboard-sa
kubectl apply -f deployment-def.yml
kubectl get deployment web-dashboard
kubectl describe deployment web-dashboard
kubectl get pod web-dashboard-7666579d69-2sh22
kubectl describe pod web-dashboard-7666579d69-2sh22
kubectl exec -it web-dashboard-7666579d69-2sh22 -- sh ls -al /var/run/secrets/kubernetes.io/serviceaccount
# -rw-r--r--    1 root     root          1166 Nov  5 12:00 ca.crt
# -rw-r--r--    1 root     root           660 Nov  5 12:00 namespace
# -rw-r--r--    1 root     root           660 Nov  5 12:00 token
