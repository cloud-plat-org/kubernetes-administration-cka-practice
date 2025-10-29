#!/bin/bash
source ~/awx-venv/bin/activate

cat /etc/*release*
apt-get --version
apt-get update

kubeadm version
# kubeadm version: &version.Info{
#     Major:"1", Minor:"34"
# }

kubeadm upgrade plan
# https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
# https://kubernetes.io/docs/tasks/tools/

#remove pods and cordon the node
kubectl drain node01 --ignore-daemonsets
kubectl uncordon node01
kubectl get nodes # shows worker node as v1.12.0
k get pods -A -o wide


vim /etc/apt/sources.list.d/kubernetes.list
# deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /
apt update

apt-cache madison kubeadm

1.33.0-1.1

apt-get install kubeadm=1.33.0-1.1

kubeadm upgrade plan v1.33.0 # This is a specific version of kubernetes.

kubeadm upgrade apply v1.33.0 # This is a specific version of kubernetes.

apt-get install kubelet=1.33.0-1.1
 
 # worker nodes:  ##### ssh node01 #####
apt-get install kubeadm=1.33.0-1.1

# Upgrade the node 
kubeadm upgrade node
apt-get install kubelet=1.33.0-1.1

systemctl daemon-reload
systemctl restart kubelet





## Master node upgrade
## Upgrading knods from v.1.11 to 1.12.0
apt-get upgrade -y kubeadm=1.12.0-00
kubeadm upgrade apply v1.12.0

# note that kubectl get nodes will show v1.11.0, because of the kubectl's on each node.
# There may or maynot be kubectl's on master node.
apt-get upgrade -y kubectl=1.12.0-00
systemctl restart kubelet
kubectl get nodes # shows master node as v1.12.0

## Worker node upgrade
