# Cluster Autoscaler (CA)
# Cluster Autoscaler is a tool that automatically scales the number of nodes in a Kubernetes cluster.
# It is used to ensure that the cluster has enough nodes to handle the load.

# Horizontal Pod Autoscaler (HPA)
# Horizontal Pod Autoscaler is a tool that automatically scales the number of pods in a Kubernetes cluster.
# It is used to ensure that there are enough pods to handle the load.

# Vertical Pod Autoscaler (VPA)
# Vertical Pod Autoscaler is a tool that automatically scales the resources of a pod.
# It is used to ensure that the pod has the right resources to handle the load.

#HPA Commands
kubeclt top pods <pod-name>
# note must have the metrics server installed
## this is manually scaling the deployment.
kubectl scale deployment <deployment-name> --replicas=<number-of-replicas>
# HPA - observe the metrics and scale the deployment automatically
#     - based on the metrics, the HPA will add or remove pods to the deployment
#     - the HPA will balance the load across the pods

# HPA - automatically scale the deployment based on the metrics
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
#  the HPA reads the thresholds on the resource requests and limits.
#  The HPA monitors the metrics servers for the pods in the deployment.
#  Then when the pods reach 50% of the requests, the HPA will add 1 pod to the deployment.
kubectl get hpa
kubectl delete hpa my-app
kubectl create -f my-app-hpa.yml
# HPA is dependent on the metrics server.
# Custom adapter and metrics are supported by the HPA.
# External adapters and metrics are supported by the HPA.
# Dynatrace, Datadog, Prometheus, etc.
k get hpa --watch

# Inplace Pod Resizing (manual scaling)
kubectl replace -f inplace-pod-resizing.yml
k edit pod inplace-pod-resizing
# https://kubernetes.io/docs/tasks/configure-pod-container/resize-container-resources/
kubectl patch pod resize-demo --subresource resize --patch \
  '{"spec":{"containers":[{"name":"pause", "resources":{"requests":{"cpu":"800m"}, "limits":{"cpu":"800m"}}}]}}'

# Alternative methods:
# FEATURE_GATES=InPlacePodVerticalScaling=true 
#   kubectl replace -f <updated-manifest> --subresource resize --server-side
# only works for cpu and memory.
# INIT containers and ephemeral containers can't be resized.
# Resizing a pod will not change the pod's QOS class.
# Resource requests and limits can't be moved once set.
# A containers memory limit can not be less than the previous request.
# Windows pods can't be resized.

# Resize Policy
kubectl create -f resize-policy-deployment.yml
kubectl replace -f resize-policy-deployment.yml
kubectl edit deployment resize-policy-deployment
kubectl patch deployment resize-policy-deployment --subresource resize --patch \
  '{"spec":{"template":{"spec":{"containers":[{"name":"my-app", "resources":{"requests":{"cpu":"800m"}, "limits":{"cpu":"800m"}}}]}}}}'



# VPA Commands
# Maual # requires Metrics Server
kubectl top pod <pod-name> <container-name>
# See utilisation metrics for the pod and container.

# if changes:
kubectl edit pod <pod-name>
kubectl replace --force -f <pod-name>.yml
# --force will delete the pod and create a new one with the new changes.

# VPA - automatically scale the resources of a pod based on the metrics.
#     - based on the metrics, the VPA will add or remove resources to the pod.
#     - meaning it it gives more memory or cpu to the pod if it is overloaded.
#     - the VPA will balance the load across the resources.
# VPA does not come built in with kubernetes.
# You need to install it.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/vertical-pod-autoscaler/deploy/vpa-recommended.yaml
### vpa-admission-controller.yaml creates new pods with the recommended resources.
### vpa-recommender.yaml Monitors the metrics server and recommends the resources to the pod.
### vpa-updater.yaml Evicts the pod if the resources are not enough.

kubectl get vpa --watch
kubectl get vpa <vpa-name>
kubectl delete vpa <vpa-name>
kubectl describe vpa <vpa-name>

# Feature						VPA (Vertical Scaling)								HPA (Vertical Scaling)
# Scaling Method				Increase CPU and memory of existing Pods			Adds/Removed Pods based on load

# Pod Behvior					Restarts Pods to apply new resources values			Keeps existing Pods running

# Handles Traffic Spikes?		No, because scaling requires a Pod restart			Yes, instanty adds more Pods

# Optimized Costs?				Prevents over-provisioning of CPU/memory			Avoids unnecerrary idle Pods

# Best For						Stateful workloads, CPU/memory-heavy-apps			Web apps, microservices, stateless services
# 								(DB, ML workloads)

# Example use cases:            DB, (mysql, postgres, etc.) JVM based apps          Web services (NGINX, API services) Message queues (RabbitMQ, Kafka)
#                               AI, ML, (tensorflow, pytorch, etc.)                 microservices, stateless services


k get crd -A
# NAME                                                  CREATED AT
# verticalpodautoscalercheckpoints.autoscaling.k8s.io   2025-10-23T20:36:47Z
# verticalpodautoscalers.autoscaling.k8s.io             2025-10-23T20:36:47Z

kubectl apply -f /root/vpa-crds.yml # fix path to vpa-crds.yml 
kubectl apply -f /root/vpa-rbac.yml # fix path to vpa-rbac.yml 
### SEE OUTPUT BELOW ^^^ ###
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler
./hack/vpa-up.sh

# How many VPA's run on a kube-system namespace?
kubectl get deployments -n kube-system | grep vpa
# vpa-admission-controller   1/1     1            1           25m
# vpa-recommender            1/1     1            1           25m
# vpa-updater                1/1     1            1           25m

# grep c = before and after, grep b = before, grep a = after
k logs vpa-admission-controller-76f55f79cc-qq8xq -n kube-system | grep -C 2 "pattern" filename
k logs vpa-recommender-588485c64b-67xmj -n kube-system | grep -B 2 -A 2 "pattern" filename
k logs vpa-updater-75d58448cf-rcpwr -n kube-system | grep -C 2 "pattern" filename
# "Too few replicas" error means the VPA is not able to scale the pod. More that one pod is required.

kubectl logs $(kubectl get pods -n kube-system --no-headers -o custom-columns=":metadata.name" | grep vpa-updater) -n kube-system
# pods_eviction_restriction.go:226] too few replicas for ReplicaSet default/flask-app-b6c9c4f78. Found 1 live pods, needs 2 (global 2)

kubectl logs $(kubectl get pods -n kube-system --no-headers -o custom-columns=":metadata.name" | grep vpa-updater) -n kube-system

kubectl scale deployment flask-app --replicas=2

kubectl get deployment flask-app -o wide
# make sure 2 pods are running

kubectl get pods -l app=flask-app
# label is app=flask-app
# NAME                         READY   STATUS    RESTARTS   AGE
# flask-app-67b666c5fc-jrc9d   1/1     Running   0          77s
# flask-app-67b666c5fc-rvt9d   1/1     Running   0          62s

kubectl describe vpa flask-app
# See recommendations applied CPU and memory, and logs for the VPA.


## VPA CPU Optimization Lab ##
 k apply -f vpa-cpu-testing.yml
 k top pod
# NAME                           CPU(cores)   MEMORY(bytes)   
# flask-app-4-7dcd9549fc-cs2dj   1m           19Mi            
# flask-app-4-7dcd9549fc-q7cl5   1m           19Mi   

k apply -f vpa-cpu.yml 
# verticalpodautoscaler.autoscaling.k8s.io/flask-app created
k get vpa
# NAME        MODE   CPU    MEM   PROVIDED   AGE
# flask-app   Off    100m         True       59s
./load.sh
# keep the load running in the background.
# You can terminate the load by pressing Ctrl+C.
k get vpa


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
























