#! /bin/bash

#  A docker-registry type secret is for accessing a container registry.

#  A generic type secret indicate an Opaque secret type.

#  A tls type secret holds TLS certificate and its associated key.


echo -n "MySQL" | base64
echo -n "123456" | base64 -decode

kubectl create -f secret-data.yml
kubectl create -f pod-definition.yml

## Secrets in Pods as a volume
kubectl create -f pod-definition-volume.yml
