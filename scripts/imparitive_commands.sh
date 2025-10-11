## Reference: See exam_tips/dryruns.md for detailed dry-run examples and best practices
## reference: https://kubernetes.io/docs/reference/kubectl/conventions/

# pod name and image name must be unique
kubectl run nginx-pod --image=nginx:alpine --dry-run=client -o yaml
kubectl run nginx-pod --image=nginx:alpine

# replace the pod with the new one
kubectl replace --force -f nginx-alpine2.yml 

kubectl run redis --image=redis:alpine --dry-run=client -o yaml -l="tier=db" > redis-alpine.yml
kubectl run redis --image=redis:alpine --dry-run=client -l="tier=db"
kubectl get pod redis
kubectl describe pod redis

# create a service for the pod  ## this is wrong
kubectl create service clusterip redis-servcie --tcp=6379:6379 --dry-run=client -o yaml > redis-service.yml
kubectl apply -f redis-service.yml
kubectl get service redis-servcie
kubectl describe service redis-servcie

#best for creating services for a pod ## this is correct
kubectl expose pod redis --port=6379 --name=redis-service
kubectl get service redis-service
kubectl describe service redis-service

# create a deployment for the pod
kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3
kubectl get deployment webapp
kubectl describe deployment webapp

# create a pod with a custom port
kubectl run custom-nginx --image=nginx --port=8080
# create a service for the pod
kubectl expose pod custom-nginx --port=8080 --name=custom-nginx-service
kubectl get service custom-nginx-service
kubectl describe service custom-nginx-service

# create a namespace
kubectl create namespace dev-ns
kubectl get namespace
kubectl describe namespace dev-ns

# create a deployment in the namespace
kubectl create deployment redis-deploy -n dev-ns --image=redis --replicas=2
kubectl get deployment -n dev-ns
kubectl describe deployment redis-deploy -n dev-ns

# create a pod with a custom port
kubectl run httpd --image=httpd:alpine
kubectl expose pod httpd --name=httpd --port=80
kubectl get service httpd
kubectl describe service httpd
## Better way to create a service for a pod
kubectl run httpd --image=httpd:alpine --port=80 --expose=true
kubectl get service httpd
kubectl describe service httpd

kubectl edit pod/awx-web-7d5c774c65-4qdh4 -n=awx

kubectl get nodes
kubectl create -f nginx.yml
kubectl get pods
# Why pending?
kubectl get pods -n kube-system
kubectl get pods -n kube-system | grep scheduler

kubect replace --force -f nginx.yml
kubectl get pods -n kube-system | grep scheduler

kubectl get pods -o wide

kubectl get pods --selector app=nginx

kubectl get pods --selector env=dev -o wide
kubectl get pods --selector env=dev --no-headers | wc -l

kubectl get pods --selector bu=finance -o wide
kubectl get pods --selector bu=finance --no-headers | wc -l

kubectl get pod --selector env=prod,bu=finance,tier=frontend -o wide
kubectl get pod --selector env=prod,bu=finance,tier=frontend --no-headers | wc -l
kubectl get pod --selector env=prod,bu=finance,tier=frontend --no-headers | wc -l

kubectl apply -f replicaset-definition-1.yaml 

kubectl describe node minikube | grep Taint
# Taints:             <none>

#  reference: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
kubectl taint nodes node-name key=value:PreferNoSchedule
kubectl taint nodes node-name key=value:NoSchedule
kubectl taint nodes node-name key=value:NoExecute
kubectl describe node node-name | grep Taint
kubectl taint nodes note1 app=myapp:NoSchedule

kubectl get nodes --all-namespaces
kubectl describe nodes node01 | grep Taint
# add the taint to the node
kubectl taint nodes node01 spray=mortein:NoSchedule

kubectl run bee --image=nginx --dry-run=client -o yaml > bee.yml
kubectl apply -f bee.yml
kubectl get pod bee -o wide
kubectl get pods --watch  # watch the pod bee ?

# remove the taint -
kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get pod mosquito -o wide

#label the node
kubectl label nodes node01 size=Large
kubectl get nodes --show-labels

# Cluserter info
kubectl cluster-info
kubectl get nodes -o wide

kubectl delete deployment blue
kubectl delete deployment blue -n <namespace-name>
kubectl delete deployment blue --force --grace-period=0

kubectl delete <resource-type> <resource-name> -n <namespace-name>

kubectl label nodes node01 color=blue
kubectl get nodes --show-labels
kubectl get nodes node01 --show-labels

kubectl get daemonset -n cluster --all-namespaces
kubectl describe daemonset -n kube-system # look in namespace for describe?
kubectl describe daemonsets kube-proxy -n kube-system # not this is correct
kubectl describe ds kube-flannel-ds -n kube-system
kubectl create -f daemon-set-definition.yml
kubectl create deployment elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:v2.5.2 -n kube-system -o yaml > daemonset-elasticsearch.yml
# Convert output to type daemonset
kubectl create -f daemonset-elasticsearch.yml
kubectl get daemonset -n kube-system
kubectl delete daemonset elasticsearch -n kube-system

## Static Pods
# only the command can be after the --command flag
kubectl run static-busybox \
  --image=busybox \
  --restart=Never \
  --namespace=default \
  --dry-run=client -o yaml \
  --command -- sleep 1000
ls /etc/kubernetes/manifests


kubectl get pod static-busybox -n default -o yaml
kubectl get pods -A --watch
# look up owner references for pod if static pod node, -replicaSet if replicaset pod
# The node name at the end of the pod name if static pod
cat /var/lib/kubelet/config.yaml
staticPodPath: /etc/kubernetes/manifests # this is the path for static pods?

kubectl exec -it <pod-name> -- <command>
kubectl exec -it node01 -- ls -al /etc/kubernetes/manifests

# Priority Class
kubectl get priorityclass
kubectl get priorityclass system-cluster-critical -o yaml
kubectl describe priorityclass system-cluster-critical
kubectl describe priorityclass system-node-critical -o yaml
kubectl delete priorityclass high-priority

# https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/
## custom-scheduler.yml, scheduler-config.yml, custom-scheduler-pod.yml
kubectl get pods -n kube-system | grep scheduler
kubectl get pods -n kube-system | grep custom-scheduler
kubectl get events -n kube-system -o wide 
    --sort-by='.metadata.creationTimestamp'
kubectl get serviceaccount -n kube-system
kubectl get clusterrolebinding
kubectl describe pod kube-scheduler-controlplane --namespace=kube-system
kubectl get serviceaccount kube-scheduler -n kube-system -o yaml # serviceaccount or sa
kubectl get clusterrolebinding kube-scheduler -o yaml
kubectl create configmap custom-scheduler-config --from-file=scheduler-config.yml -n kube-system
# use same image as the default scheduler


## Viewing Enable Admission Controllers (usage)
# Access kube-apiserver help in minikube (runs as a container, not a binary)
kubectl exec kube-apiserver-minikube -n kube-system -- kube-apiserver -h
# Or check specific options/flags:
kubectl exec kube-apiserver-minikube -n kube-system -- kube-apiserver -h | grep enable-admission-plugins
# apiserver-enable-admission-plugins.md
## How to enable creating namespaces automatically
kube-apiserver.service
# --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision # deprecated
# Please be aware that the NamespaceExists and NamespaceAutoProvision admission controllers have been deprecated and
# are now succeeded by the NamespaceLifecycle admission controller.
# The NamespaceLifecycle admission controller ensures that any requests made to a non-existent namespace are rejected, 
# and it safeguards the default namespaces, including default, kube-system, and kube-public, from being deleted.
# --disable-adminsion-plugins= DefaultStorageCass
# yml/kube-apiserver.yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml
kubectl exec -it kube-apiserver-minikube -n kube-system -- kube-apiserver -h | grep enable-admission-plugins
grep -i enable-admission-plugins /etc/kubernetes/manifests/kube-apiserver.yaml
## mutating admission controller vs validating admission controller
<--- apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 0.5Gi
      --->
  # pvc (persistent volume claim)
kubectl get pvc myclaim -o yaml
# Since the kube-apiserver is running as pod you can check the process to see enabled and disabled plugins.
ps -ef | grep kube-apiserver | grep admission-plugins

## Admission Controller (validating and mutating)
# AllwaysPullImages
# DefaultStorageClass
# EventRateLimit
# NamespaceAutoProvision - mutating
# NamespaceExists - validating
# NamespaceLifecycle
# NodeRestriction
#  Many more...

# ValidatingAdmissionWebhook - validating
# MutatingAdmissionWebhook - mutating
# ValidatingAdmissionPolicy - validating
# MutatingAdmissionPolicy - mutating

https://github.com/kubernetes/kubernetes/blob/v1.13.0/test/images/webhook/main.go

kubectl create namespace webhook-demo
kubectl -n webhook-demo create secret tls webhook-server-tls \
    --cert "/root/keys/webhook-server-tls.crt" \
    --key "/root/keys/webhook-server-tls.key"

kubectl apply -f yml/webhook-deployment.yml
kubectl apply -f yml/webhook-service.yml
kubectl apply -f yml/webhook-MutatingWebhookConfiguration.yml

# verify the security context of the pod
kubectl create ns webhook-demo
kubectl edit pod pod-with-conflict



