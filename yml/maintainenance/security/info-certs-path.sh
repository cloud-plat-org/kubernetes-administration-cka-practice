


kubectl get pods -n kube-system
k describe pod etcd-controlplane -n kube-system

k describe pod kube-apiserver-controlplane -n kube-system | grep apiserver.crt
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout







