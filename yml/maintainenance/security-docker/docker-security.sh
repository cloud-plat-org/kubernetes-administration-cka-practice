#! /bin/bash

docker run ubuntu sleep 3600

# the node has its own namespace.
# The pods have their own namespace.
#   the containers run in the namespace of the pod.
#   The containers can only see it's own processes, not anything outside of container, or any other namespace.
# pads run as there own service:
ps aux # run on the container.
# when you see the sleep process, you see the process id of 1.
ps aux # run on the node:
    # you will see the sleep process but under a different process id.
    
# Users
# docker runs processes on containers as the root user.
# if you don't want to run as root, you can user the --user flag to run as a specific user.
docker run --user 1001:1001 ubuntu sleep 3600
# Specifying the user and group IDs
# docker.file:
# From: ubuntu
# User: 1001
# Group: 1001
# now if you create a custom image, the process will run as the user and group specified in the docker.file.
docker build -t my-ubuntu-image .
docker run my-ubuntu-image sleep 3600
ps aux | grep sleep 
# user: 1001

# Is the root user on the host the same as the root user on the container?
# Can the process do anything that the root user can do on the host?
# the root user on the container is not the same as the root user on the host.

# Linux capabilities:
# The root user on the host has all the capabilities.
# Processes run by the root user on the host have all the capabilities.
/include/security/capability.h
docker runs a container with a limited set of capabilities:
# BROADCAST, SYS_ADMIN, SYSLOG, MAC_ADMIN, NET_ADMIN, etc. # these are linux capabilities.
# If you wish to override the default capabilities, you can use the --cap-add flag to add the capabilities.
docker run --cap-add SYS_ADMIN ubuntu sleep 3600
ps aux | grep sleep 
# user: root
# capabilities: SYS_ADMIN
docker run --cap-drop ALL ubuntu sleep 3600
ps aux | grep sleep 
# user: root
# capabilities: none
docker run --privileged ubuntu sleep 3600
ps aux | grep sleep 
# user: root
# capabilities: all

# KUBERNETES SECURITY CONTEXT:
# Kubernetes security context is a set of properties that can be applied to a pod or a container.
# It is used to configure the security of a pod or a container.
# If set at the pod level, it applies to all containers in the pod.

kubectl exec ubuntu-sleeper -- whoami
# root
kubectl exec ubuntu-sleeper -- id
# uid=1001(root) gid=1001(root) groups=1001(root)
kubectl exec ubuntu-sleeper -- ps aux
# user: root
# capabilities: SYS_ADMIN, NET_ADMIN
kubectl exec ubuntu-sleeper -- ip addr
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

k edit pod ubuntu-sleeper
# better way to edit the pod:
kubectl get pod ubuntu-sleeper -o yaml > ubuntu-sleeper.yml
vim ubuntu-sleeper.yml
## look for this: /securityContext 
# Add the following:
# securityContext:
#   runAsUser: 1001
#   capabilities:
#     add:
#       - SYS_ADMIN
#       - NET_ADMIN

k replace -f /tmp/kubectl-edit-47656155.yaml --force

k replace -f yml/ubuntu-sleeper.yml --force










