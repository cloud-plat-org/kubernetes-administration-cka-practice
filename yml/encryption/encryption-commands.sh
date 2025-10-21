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

# Generate encryption key
head -c 32 /dev/urandom | base64

minikube ssh "sudo mkdir -p /etc/kubernetes/enc"

# Step 2: Copy encryption config to minikube
minikube cp /home/dan_i/learn/cka/yml/encryption/enc.yml /tmp/enc.yml
minikube ssh "sudo mv /tmp/enc.yml /etc/kubernetes/enc/enc.yml"
minikube ssh "sudo chmod 600 /etc/kubernetes/enc/enc.yml"

# Step 3: Verify the file is in place
minikube ssh "sudo ls -la /etc/kubernetes/enc/"

# Step 4: Manually edit the kube-apiserver manifest
# Add the following to the kube-apiserver.yaml:
#
# Under spec.containers[0].command, add:
#   - --encryption-provider-config=/etc/kubernetes/enc/enc.yml
#
# Under spec.containers[0].volumeMounts, add:
#   - mountPath: /etc/kubernetes/enc
#     name: enc
#     readOnly: true
#
# Under spec.volumes, add:
#   - hostPath:
#       path: /etc/kubernetes/enc
#       type: DirectoryOrCreate
#     name: enc

# You can do it manually with:
minikube ssh

# Then inside minikube:
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml

# Step 5: Wait for apiserver to restart (it will detect the change automatically)
kubectl get pods -n kube-system -w

# Step 6: Verify encryption is enabled
kubectl get pod -n kube-system kube-apiserver-minikube -o yaml | grep encryption-provider-config

# Step 7: Create a test secret
kubectl create secret generic test-secret -n default --from-literal=mykey=mydata

# Step 8: Verify it's encrypted in etcd
kubectl exec -n kube-system etcd-minikube -- sh -c "ETCDCTL_API=3 etcdctl \
   --cacert=/var/lib/minikube/certs/etcd/ca.crt \
   --cert=/var/lib/minikube/certs/etcd/server.crt \
   --key=/var/lib/minikube/certs/etcd/server.key \
   get /registry/secrets/default/test-secret" | hexdump -C

# You should see "k8s:enc:aescbc:v1:key1:" at the beginning if encrypted
# Compare with old secrets that show "k8s:enc:identity:v1:" (not encrypted)

# Step 9: Re-encrypt all existing secrets
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

crictl pods

# Check what's available in minikube
minikube ssh "cat /etc/os-release"
# Try installing vim (if using buildroot/alpine)
minikube ssh "sudo apt-get update && sudo apt-get install -y vim"

kubectl create secret generic my-secret --from-literal=key2=topsecret
# secret/my-secret created
kubectl get secret my-secret -o yaml
# secret/my-secret created
kubectl get secret my-secret -o json
# secret/my-secret created
kubectl get secret my-secret -o jsonpath='{.data.key2}' | base64 --decode
# topsecret
kubectl get secret my-secret -o jsonpath='{.data.key2}' | base64 --decode