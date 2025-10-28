
# None of the control services can be higher than the kube-apiserver:
kube-apiservers vX v1.10

Controller-manager vX-1 (v1.9 or v1.10)
kube-scheduler vX-1 (v1.9 or v1.10)

kubelet vX-2 (v1.8 or v1.9 or v1.10)
kube-proxy vX-2 (v1.8 or v1.9 or v1.10)

kubectl vX+1 > vX-1 (v1.11 or v1.9 or v1.10)

# Upgrage one minor version at a time.
Manged services often one click upgrades.
kubeadm plan, kubeadm apply (Thought in course.)
Manual updates, the hardest way.

References
https://kubernetes.io/docs/concepts/overview/kubernetes-api/

Here is a link to kubernetes documentation if you want to learn more about this topic (You don't need it for the exam though):

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api_changes.md

