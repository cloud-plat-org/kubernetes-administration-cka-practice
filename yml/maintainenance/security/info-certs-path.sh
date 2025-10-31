#! /bin/bash

# Auth Mechanisms  (NOT RECOMMENDED)
kube-appiserver
# Static Token File
#   --token-auth-file=user-token-details.csv
#   curl -k -H "Authorization: Bearer <token>" https://<kube-apiserver-ip>:8443/api/v1/namespaces/default/pods

# Certificate
# Idetity Service



# TLS Certificates Paths
# symmetric encryption 
#   # key (lock)
# how do we get this to the nodes (apiserver)?
# asymmetric encryption 
        # public key (lock) / private key

sshkeygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
id_rsa (private key)
id_rsa.pub (public key) (lock
cat ~/.ssh/authorized_keys # public key is stored in the authorized_keys file
   # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+... user1
ssh -i id_rsa user@host # specific private key path (id_rsa)

# How do we get this on the nodes?
# on server side (generate the key pair)
openssl genrsa -out my-bank.key 2048 (private key)
openssl rsa -in my-bank.key -pubout -out my-bank.pem (public key)

# Use access the server using https, he get a public key, 
# he uses the public key to encrypt the symmetric key, 
# he sends the encrypted symmetric key to the server, 
# the server uses the private key to decrypt the symmetric key, 
# the user can now send username and password to the server using the symmetric key
# now that both the user and the server have the symmetric key, 
# they can use it to encrypt and decrypt the data

# hacker make a mock server with a private key and public key
# he tweeks your browser to use his server instead of the real one
# the mock server sends you the public key, you use it to encrypt the symmetric key
# he can now decrypt the username and password using the symmetric key gotten from you
# to stop this, you can use a certificate to authenticate the server
# the certificate is sent to the user with the public key
# the user can now use the certificate to authenticate the server
# all web browsers have a certificate validation mechanism
# how do you generate a certificate that is trusted by the browser?
# Certificate Authority (CA)
# the CA is a trusted entity that issues certificates
# Symantec, Comodo, GloabalSign, DigiCert, etc.
openssl req -new -key my-bank.key -out my-bank.csr /
 -subj "/C=US/ST=California/L=San Francisco/O=My Company/OU=IT Department/CN=my-bank.com"
 # my-bank.key (private key) 
 # my-bank.csr (certificate signing request)
    # Certificate Signing Request (CSR), 
    # Validation of the request is done by the CA 
    #    (makes sure you are who you say you are)
    # Sign the certificate with the CA's private key
# The CA generates a signed certificate from your CSR
# You receive: my-bank.crt (signed certificate)
# This certificate contains:
#   - Your public key (from the CSR)
#   - Your identity info (from the CSR)  
#   - CA's signature (created with CA's private key)
#   - Validity period, serial number, etc.

# To verify a certificate:
openssl x509 -in my-bank.crt -text -noout
# if you need this for internal use:
  # Companies can create their own CA or 
  # pay for a CA to issue certificates for internal use


# on client side
# To keep the user from being spoofed, 
# The users can create a csr and get there own Certificate.
# This certificate can be authenticated by the server using the CA's public key
    ##### THIS IS THE BEST WAY TO AUTHENTICATE THE USER ####
    ##### THIS is called Public Key Infrastructure (PKI) ####
    ##### This is the best way to authenticate the user ####
# note: The public key and private key can both be used 
# to encrypt and decrypt the data

# public key (lock) .crt, .pem
# server.crt, server.pem (server's public key)
# client.crt, client.pem (client's public key)
# Private key (key) .key, .pem
# server-key.pem, server.key (server's private key)
# client.key, client.key.pem (client's private key)
#  the one with .key or key in the name is the private key
#  the one with .crt or pem in the name is the public key





kubectl get pods -n kube-system
k describe pod etcd-controlplane -n kube-system

k describe pod kube-apiserver-controlplane -n kube-system | grep apiserver.crt
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

### openssl certificate commands ###
openssl genrsa -out ca.key 2048 (first a private key)
# next create a certificate signing request
openssl req -new -key ca.key -subject "/CN=KUBERNETES-CA" -out ca.csr
# Sign the certificate
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
# we now have ca.crt (certificate) and ca.key (private key)

# Client Certificates
# NEXT: we creat the admin user certificate
openssl genrsa -out admin.key 2048 (private key)
openssl req -new -key admin.key -subject "/CN=kube-admin/OU=system:masters" -out admin.csr (certificate signing request)
# Group: system:masters
# Sign the certificate
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt (note: signed with ca.crt ca.key)
# we now have admin.crt (certificate) and admin.key (private key)
## Kube Scheduler Certificate
# must be prefixed with system:kube_scheduler, same with system:kube-controller-manager, and system:kube-proxy
# we now have admin.crt (certificate) and admin.key (private key)
# we now have kube-scheduler.crt (certificate) and kube-scheduler.key (private key)
# we now have kube-controller-manager.crt (certificate) and kube-controller-manager.key (private key)
# we now have kube-proxy.crt (certificate) and kube-proxy.key (private key)

# Service Certificates
# etcd server certificate
cat etcd.yaml
- etcd

# kube-apiserver certificate
apiserver.crt, apiserver.key
kubernetes
kubernetes.default
kubernetes.default.svc
kubernetes.default.svc.cluster.local
ipaddress: 10.96.0.1, 172.16.0.1
openssl genrsa -out apiserver.key 2048
apiserver.key
openssl req -new -key apiserver.key -subject "/CN=kube-apiserver" -out apiserver.csr
apiserver.csr
# How do you include all the names in the certificate?
openssl req -new -key apiserver.key -subject "/CN=kube-apiserver" -out apiserver.csr -config openssl.cnf
openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation,
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 172.16.0.1

openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out apiserver.crt -extensions v3_req -extfile openssl.cnf \
  -days 1000
# apiserver.crt

#Kube-api Server (server configuration file) (Considering client authentication)
# First the ca file needs to be passed in.
# --client-ca-file=/var/lib/kubernetes/ca.crt

# then the api certificate needs to be passed in.
# --tls-cert-file=/var/lib/kubernetes/apiserver.crt
# then the api private key needs to be passed in.
# --tls-private-key-file=/var/lib/kubernetes/apiserver.key

# then for etcd the client CA certificate needs to be passed in.
# --etcd-cafile=/var/lib/kubernetes/etcd/ca.crt
# then for etcd the client certificate needs to be passed in.
# --etcd-certfile=/var/lib/kubernetes/etcd/server.crt
# then for etcd the client private key needs to be passed in.
# --etcd-keyfile=/var/lib/kubernetes/etcd/apiserver-etcd-client.key

# then for kubelet the client CA certificate needs to be passed in.
# --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem
# then for kubelet the client certificate needs to be passed in.
# --kubelet-client-certificate=/var/lib/kubernetes/apiserver-kubelet-client.crt
# then for kubelet the client private key needs to be passed in.
# --kubelet-client-key=/var/lib/kubernetes/apiserver-kubelet-client.key


# kubelet
# kubelet.crt (certificate)
# kubelet.key (private key)
# Each certificate is named after the node (system:node:<node-name>).
# kubelet-config.yml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  x509:
    clientCAFile: "/var/lib/minikube/certs/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  addresses:
  - 10.96.0.10
podCIDR: "$POD_CIDR"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/pki/kubelet.crt"
tlsPrivateKeyFile: "/var/lib/kubelet/pki/kubelet.key"


########################### Kubernetes certificate healthchecks ###########################
# Manual (hard way)
cat /etc/systemd/system/kubelet.service
[Service]
ExecStart=/usr/local/bin/kube-apiserver \
# kubeadm (easy way)
cat /etc/kubernetes/manifests/kube-apiserver.yaml
cat /etc/kubernetes/manifests/etcd.yaml 
# get excel spreadsheet of all the certificates and their paths
# /etc/kubernetes/pki/apiserver.crt
openss x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
# name: Subject CN=kube-apiserver
# alternetneme: list all

journalctl -u etcd.service -l
kubectl logs etcd-master
# use docker to list containers
crictl ps --all
crictl inspect
crictl logs 89c877c94b761
# not docker use crictl to list containers
docker ps --all | grep kube-apiserver
doceker logs 89c877c94b761
# port 2379 is the etcd port *
# port 6443 is the apiserver port
docker ps -a | grep etcd
docker logs <container-id>
# check path of error:
ls /etc/kubernetes/pki/etcd/
# server.crt, server.key, ca.crt # no kube-apiserver.crt or kube-apiserver.key
# after fixing the path
docker ps -a | grep kube-apiserver  # look for the times the container was restarted

#kubeadm documentation spreadsheet
# certificate path
# CN Name
# ATL Name
# Organization
# Issuer
# Expiration Date


# Serial Number
# Subject Alternative Names
# Issuer Alternative Names
# Subject Key Identifier
# Authority Key Identifier
# Basic Constraints
# Key Usage
# Extended Key Usage
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
# https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
# https://kubernetes.io/docs/tasks/tls/certificate-issue-client-csr/

# What is the Common Name (CN) configured on the Kube API Server Certificate?
OpenSSL Syntax: openssl x509 -in file-path.crt -text -noout
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout
openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout

diff -u /home/dan_i/learn/cka/yml/maintainenance/security/etcd.yml /home/dan_i/learn/cka/yml/maintainenance/security/test.yml
diff -u /home/dan_i/learn/cka/yml/maintainenance/security/kube-apiserver.yml /home/dan_i/learn/cka/yml/maintainenance/security/test-apiserver.yml

### notice that the apiserver certs are under /etc/kubernetes/pki/ and
### the etcd certs are under /etc/kubernetes/pki/etcd/

# master node is the CA server
# certificate API server is the CA server
# When admin gets a csr, he creates a 
# 1> CertificateSigningRequest object
# 2> Reviewed by the admin
# 3> Approved or Denied
# 4> Certificate is issued

# New User
openssl genrsa -out user.key 2048
openssl req -new -key user.key -subject "/CN=user" -out user.csr
# user.key (private key)
# user.csr (certificate signing request)
# Sends the csr to the admin
# The admin creates a CertificateSigningRequest object
cat user.csr | base64 -w 0 # copy the output and paste it into the csr request file
# yml/maintainenance/security/csrequest.yml
# kubectl apply -f yml/maintainenance/security/csrequest.yml
# kubectl get csr
# kubectl certificate approve jane
# kubectl certificate deny jane
# k delete csr jane


# kubectl get csr jane -o yaml | grep certificate | base64 -d > user.crt
# echo AAAKDIGakd.. | base64 -decode > user.crt
### This is all done by the controller manager ###
CSR-APPROVING
CSR-SIGNING
cat /etc/kubernetes/manifests/kube-controller-manager.yaml

# How user certs are used and referenced for kube-apiserver
kubectl get pods -n kube-system --kubeconfig config.yml
# The reason the --kubeconfig is not needed is because the 
# kubeconfig file is already in the .kube/ directory .kube/config
cat ~/.kube/config # This is the kubeconfig file

# Three main components of the kubeconfig file:
# clusters: list of clusters (development)
#   --server https://development:6443
# contexts: context ties a cluster to a user (admin@development)
# users: list of users (admin)
#   --client-key admin.key
#   --client-certificate admin.crt
#   --certificate-authority ca.crt
kubectl config view
kubectl config view --kubeconfig=my-custom-config.yml
# how do you choose the context?
kubectl config use-context admin@development
kubectl config -h
# namespace can be added to the context if it is in the cluster
kubectl config set-context --current --namespace=development

# Secify the path in the kubeconfig file
#    certificate-authority: /etc/kubernetes/pki/ca.crt
#     or 
#    certificate-authority-data: cat ca.crt | base64 -w 0

echo "AAAAB3NzaC1yc2EAAAADAQABAAACAQC" | base64 -decode > ca.crt
# change from default kubeconfig to my-custom-config.yml
kubectl config use-context admin@development --kubeconfig=my-custom-config.yml
# or to make it the default path for kubectl
KUBECONFIG=my-custom-config.yml kubectl get pods
# add to ~/.bashrc
export KUBECONFIG=my-custom-config.yml
vim ~/.bashrc 
source ~/.bashrc 
# now kubectl will use the custom kubeconfig file
kubectl get pods

curl -k https://development:6443/version
curl -k https://development:6443/api/v1/namespaces/default/pods
/metrics # health check
/healthz # health check
/api # api server (core groups) *
/apis # api server (named groups) *
/logs # logs for third party integrations











