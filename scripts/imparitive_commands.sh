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
kubectl get ns
kubectl edit pod pod-with-
kubectl get pod pod-with-defaults -n webhook-demo -o yaml grep -A 5 securityContext

kubectl create secret tls webhook-server-tls -n webhook-demo \
    --cert "/root/keys/webhook-server-tls.crt" \
    --key "/root/keys/webhook-server-tls.key"

kubectl get secret webhook-server-tls -n webhook-demo

# https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/
# https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/
# https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/

# Open Source:
#   Metrics Server
#   Prometheus
#   Elastic Stack
    # Heapster - deprecated
# Paid:
#   Datadog
#   Dynatrace

Metrics Server
# https://github.com/kubernetes-sigs/metrics-server
    cAdvisor
    kubelet
minikube addons enable metrics-server
git clone https://github.com/kubernetes-sigs/metrics-server.git
cd metrics-server
kubectl apply -f deploy/1.8+

kubectl get pods -n kube-system | grep metrics-server
kubectl get pods -n kube-system | grep elasticsearch
kubectl get pods -n kubernetes-dashboard | grep dashboard
elasticsearch-9dbfb9475-ptmwg -n kube-system
metrics-server-85b7d694d7-nmh7h -n kube-system
dashboard-metrics-scraper-77bf4d6c4c-qqvmn -n kubernetes-dashboard
kubernetes-dashboard-855c9754f9-rhq6t -n kubernetes-dashboard

kubectl top node
kubectl top pod -A
# NAME       CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
# minikube   148m         1%       981Mi           26%     
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
docker run kodekloud/event-simulator:1.0
 kubectl apply -f yml/event-simulator.yml
 kubectl logs event-simulator-pod

## Roleout and Versioning
kubectl create deployment nginx --image=nginx
kubectl rollout status deployment nginx

# For coredns (in kube-system namespace)
kubectl rollout status deployment coredns -n kube-system
kubectl rollout history deployment coredns -n kube-system

# For metrics-server (in kube-system namespace)
kubectl rollout status deployment metrics-server -n kube-system
kubectl rollout history deployment metrics-server -n kube-system

# For elasticsearch (in kube-system namespace)
kubectl rollout status deployment elasticsearch -n kube-system
kubectl rollout history deployment elasticsearch -n kube-system

# For dashboard deployments (in kubernetes-dashboard namespace)
kubectl rollout status deployment kubernetes-dashboard -n kubernetes-dashboard
kubectl rollout status deployment dashboard-metrics-scraper -n kubernetes-dashboard
# rollout strategy
# RollingUpdate - default
# Recreate -not preferred

kubectl apply -f yml/simple_deployment.yml
# note perfered, now simple_deployment.yml will be outdated.
kubectl set image deployment/nginx-deployment nginx=nginx:1.14.2
kubectl describe deployment nginx-deployment

kubectl rollback undo deployment nginx-deployment
kubectl get replicasets

alias k="kubectl"
echo "alias k='kubectl'" >> ~/.bashrc
source ~/.bashrc

k describe deploy frontend
k set image deploy frontend <container-name>=<image-name>

# Configure Applications
# Configuring applications comprises of understanding the following concepts:
# Configuring Command and Arguments on applications
# Configuring Environment Variables
# Configuring Secrets

docker run ubuntu
docker ps
docker ps -a
docker rm <container-id>
docker run ubuntu sleep 5
From: ubuntu
CMD: sleep 5
# Create the Dockerfile
cat > Dockerfile << EOF
FROM ubuntu
CMD ["sleep", "5"]
EOF
docker bulid -t ubuntu-sleep .
docker run ubuntu-sleep
From: ubuntu
ENTRYPOINT: ["sleep"]
CMD: ["5"] # default command
docker run ubuntu-sleep 10
docker --entrypoint sleep2.0 ubuntu-sleep 10
# CMD command parameter1
# CMD ["sleep", "5"] - First is command, rest are parameters  
docker run --name ubuntu-sleep ubuntu-sleep 10

cat > pod-definition.yml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
  - name: ubuntu-sleeper
    image: ubuntu-sleeper # ubuntu 
    command: ["sleep2.0"]
    args: ["10"]
EOF
docker run --name ubuntu-sleeper \
     --entrypoint sleep2.0

kubectl run ubuntu-sleeper --image=ubuntu-sleeper --command -- sleep 10

kubectl run webapp-gree \
  --image=kodekloud/webapp-color:v2 \
  --command python app.py -- --color green

## Environment Variables
#
# Plain Key Value Pairs
# ConfigMaps
# Secrets
# https://kubernetes.io/docs/concepts/configuration/configmap/

docker run -e NAME=Nginx
kubectl create configmap app-config \
  --from-literal=NAME=Nginx \
  --from-literal=COLOR=blue
kubectl get cm app-config -o yaml
kubectl create configmap app-config \
  --from-file=app-config.properties
kubectl get configmaps
# Declaritive:
kubectl create -f yml/config-map.yml

kubectl describe cm app-config
kubectl delete cm app-config

# app-config
APP_COLOR: blue
APP_MODE: prod
# mysql-config
port: 3306
max_allowed_packet: 128M
# redis-config
port: 6379
rdb_compression: yes

kubectl run webapp-color \
  --image=busybox \
  --restart=Never \
  --labels=name=webapp-color \
  --env=APP_COLOR=green \
  -o yaml --dry-run=client

kubectl create configmap webapp-config-map --from-literal=AP
P_COLOR=darkblue --from-literal=APP_OTHER=disregarded -o yaml
#  yml/configmap-webcolor.yml notes
kubectl edit pod webapp-color
# Make changes when fails, get path to edited file.
kubectl replace --force -f /tmp/kubectl-edit-webapp-color.yaml

##### SECRETS #####

kubectl create secret generic db-user-pass \
  --from-literal=username=admin \
  --from-literal=password=123456
kubectl get secret db-user-pass
kubectl get secret db-user-pass -o yaml
kubectl describe secret db-user-pass
kubectl delete secret db-user-pass

kubectl create secret generic db-user-pass --from-literal=username=admin --from-literal=password=123456 -o yaml > db-user-pass.yml
alias k=kubectl
k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal DB_User=root --from-literal DB_Password=password123 --dry-run=client -o yaml
# apiVersion: v1
# data:
#   DB_Host: c3FsMDE=
#   DB_Password: cGFzc3dvcmQxMjM=
#   DB_User: cm9vdA==
# kind: Secret
# metadata:
#   creationTimestamp: null
#   name: db-secret

# External Secrets Operator
# https://external-secrets.io/
# Sealed Secrets
# https://github.com/bitnami-labs/sealed-secrets
# Secrets Store CSI Driver
# https://secrets-store-csi-driver.sigs.k8s.io/
#     aws provider for secrets store csi driver
#     https://github.com/aws/secrets-store-csi-driver-provider-aws
# Provider minikube for secrets store csi driver
#     https://github.com/kubernetes-sigs/secrets-store-csi-driver-provider-minikube

kubectl get secretproviderclass
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver
kubectl get pods -n kube-system | grep secrets-store-csi-driver
#  https://www.youtube.com/watch?v=MTnQW9MxnRI

##### ENCRYPT DATA ETCD CLUSTER #####
# https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
# Includes list of providers for encryption:
# - aescbc
# - kms
# - secretbox
# - identity

/etc/kubernetes/manifests/kube-apiserver.yaml
grep encryption-provider-config /etc/kubernetes/manifests/kube-apiserver.yaml

kubectl describe pod -n kube-system kube-apiserver-minikube | grep encryption-provider-config
kubectl get pod -n kube-system kube-apiserver-minikube -o yaml | grep encryption-provider-config
--encryption-provider-config

# add encryption-configuration.yml to 
# --encryption-provider-config=encryption-configuration.yml
# in /etc/kubernetes/manifests/kube-apiserver.yaml
# then restart the kube-apiserver pod

# Multi-Container Pods
kubectl -n elastic-stack exec -it app -- cat /log/app.log

k logs -c <container-name> <pod-name>
kubectl -n elastic-stack logs kibana
k logs app

# Upgrading to a new Kubernetes version can provide new APIs.

# You can use kubectl convert command to convert manifests between different API versions. For example:
kubectl convert -f pod.yaml --output-version v1
# The kubectl tool replaces the contents of pod.yaml with a manifest that sets kind to Pod (unchanged),
# but with a revised apiVersion.

crictl ps --all
crictl logs container-id








