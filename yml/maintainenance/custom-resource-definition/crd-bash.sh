#!/bin/bash

CRD can be either Namespaced or ClusterScoped.
Namespaced: The resource is scoped to a namespace.
ClusterScoped: The resource is not scoped to a namespace.

# Deployments
kubectl create -f deployment.yml
kubectl get deployments
kubectl delete -f deployment.yml
# This all edit the etcd database.
# what creates the deployment is the Deployment controller.

# Controller
# monitors the etcd database for changes to the deployment resource.
# The monitor is an application written in go, it is part of kubernetes cluster.
# There are different controllers for different resources.

#  https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/

# Custom Resource Definition (CRD)
# What if I want to create a resource like flight ticket?
kubectl create -f flight-ticket.yml
kubectl get flighttickets
kubectl delete -f flight-ticket.yml
# This all edit the etcd database.

# If I try to run create it will fail because the resource is not defined (No controller for flight ticket)
# This will not work because the api server does not know how to handle the flight ticket resource.
# We need to define the resource in the api server.
# We can define the resource in the api server by creating a Custom Resource Definition (CRD)

kubeclt api-resources
# name, shortNames, namespaced, kind, verbs, shortNames, categories, storageVersion
# name: flightticket
# shortNames: ft
# namespaced: true
# kind: FlightTicket
# verbs: create, delete, get, list, patch, update, watch
# shortNames: ft
# categories: flights.com
# storageVersion: v1

kubectl create -f flightticket-custom-definition.yml
kubectl get crds
# Now you can create the flight ticket object.
kubectl create -f flight-ticket.yml
kubectl get flighttickets
kubectl delete -f flight-ticket.yml
# This all edit the etcd database.

# Sill needs a contoller to watch the etcd database for changes to the flight ticket object.
    # flightticket-controller.go
# https://github.com/kubernetes/sample-controller
cd ../kubernetes/sample-controller/

# Package the custom controller in a docker image.
# This could be run inside your kubernetes cluster as a pod or deployment.

# CRD ==== Resources ==== Controller 
# CRD ==== Controller 
# |=================|
#  Operator Framework
# |=================|
kubectl create -f flight-operator.yml


EtcdCluster ----- ETCDController
EtcdBackup ----- Backup Operator
EtcdRestore ----- Restore Operator
# |=================|
#  Operator Framework

# Operator Framework is a framework for building operators.
#  Operatorhub.io  is a repository of operators for the Operator Framework.
