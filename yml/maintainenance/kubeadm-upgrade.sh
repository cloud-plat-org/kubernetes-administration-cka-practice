#!/bin/bash
source ~/awx-venv/bin/activate

kubeadm version
# kubeadm version: &version.Info{
#     Major:"1", Minor:"34"
# }

kubeadm upgrade plan
# https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
# https://kubernetes.io/docs/tasks/tools/


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
#remove pods and cordon the node
kubectl drain node01 --ignore-daemonsets
apt-get upgrade -y kubeadm=1.12.0-00
apt-get upgrade -y kubectl=1.12.0-00
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet
kubectl uncordon node01
kubectl get nodes # shows worker node as v1.12.0



Master node:
kubeadm upgrade plan
kubeadm upgrade apply v1.20.0

Worker node:
kubeadm upgrade node
kubeadm upgrade node apply v1.20.0

kubectl get nodes
kubectl get pods -n kube-system