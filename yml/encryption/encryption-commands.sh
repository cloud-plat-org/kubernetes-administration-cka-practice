#! /bin/bash
source ~/awx-venv/bin/activate
# app-get install etcd-client
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt update
sudo apt install etcd-client -y

ls /etc/kubernetes/pki/etcd/ca.crt
ls /etc/kubernetes/pki/etcd/

# SSH into the minikube node
minikube ssh

# Then run the etcdctl command
ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key \
   get /registry/secrets/default/{{Secret_Name}}  | hexdump -C

# Execute etcdctl inside the etcd-minikube pod
kubectl exec -n kube-system etcd-minikube -- sh -c "ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key \
   get /registry/secrets/kubernetes-dashboard/kubernetes-dashboard-certs" | hexdump -C

# Check if secret exists
kubectl get secret secret1 -n default

# Check etcd pod is running
kubectl get pods -n kube-system -l component=etcd

ps -aux
minikube ssh "ps aux | grep kube-apiserver | grep encryption-provider-config"
minikube ssh "cat /etc/kubernetes/manifests/kube-apiserver.yaml" | grep encryption-provider-config
kubectl describe pod -n kube-system kube-apiserver-minikube | grep encryption-provider-config
kubectl get pod -n kube-system kube-apiserver-minikube -o yaml | grep encryption-provider-config
--encryption-provider-config












