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
# vpa-admission-controller.yaml creates new pods with the recommended resources.
# vpa-recommender.yaml Monitors the metrics server and recommends the resources to the pod.
# vpa-updater.yaml Evicts the pod if the resources are not enough.

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










