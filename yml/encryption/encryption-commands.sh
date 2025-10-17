#! /bin/bash
source ~/awx-venv/bin/activate
# app-get install etcd-client
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt update
sudo apt install etcd-client -y

ls /etc/kubernetes/pki/etcd/ca.crt
ls /etc/kubernetes/pki/etcd/
#  
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/{{Secret_Name}} 




