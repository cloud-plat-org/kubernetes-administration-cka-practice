#! /bin/bash 

kubectl get images

# images: nginx, This the docker image name.
# image/repository: nginx, This the docker image repository name.
# docker.io/library/nginx, This the docker image library name (default is docker.io).
# gcr.io/kubernetes-e2e-test-images/dnsutils, This the google container registry image name.

# Private Registry
docker login private-registry.io
docker run private-registry.io/apps/internal-app
#  in the nginx-pod.yml file, change the image to private-registry.io/apps/internal-app

# how do we privide the login when using nginx-pod.yml file with image: private-registry.io/apps/internal-app?
kubectl create secret docker-registry private-registry-secret \
     --docker-server=private-registry.io \
     --docker-username=admin \
     --docker-password=password \
     --docker-email=admin@private-registry.io
# imagePullSecrets:
#   - name: private-registry-secret
# in the nginx-pod.yml file, add the imagePullSecrets:

k edit deployment web 
myprivateregistry.com:5000/nginx:alpine

# Name: private-reg-cred
# Username: dock_user
# Password: dock_password
# Server: myprivateregistry.com:5000
# Email: dock_user@myprivateregistry.com

kubectl create secret docker-registry private-reg-cred \
     --docker-server=myprivateregistry.com:5000 \
     --docker-username=dock_user \
     --docker-password=dock_password \
     --docker-email=dock_user@myprivateregistry.com

# spec:
#   containers:
#   - name: nginx
#     image: nginx
#   imagePullSecrets:
#     - name: private-reg-cred

kubectl create secret # learn more about the command.
# Available Commands:
#   docker-registry   Create a secret for use with a Docker registry
#   generic           Create a secret from a local file, directory, or literal value
#   tls               Create a TLS secret











