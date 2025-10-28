# how do I install kubeadm on my WSL ubuntu instance?

To install kubeadm on your WSL Ubuntu instance, you need to follow a set of steps that are largely consistent with the official Kubernetes documentation, but with additional attention to the specific limitations and requirements of WSL (such as systemd setup and runtime compatibility).[^1][^2][^3]

### Steps to Install kubeadm on WSL Ubuntu

1. **Update your system and install dependencies**:

```
source ~/awx-venv/bin/activate

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl
```

This prepares your environment for Kubernetes tools and ensures up-to-date software sources.[^3]
2. **Add Kubernetes signing key and repository** (for older releases; recent releases use pkgs.k8s.io):

```
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
```

Replace v1.34 with the appropriate version if needed.[^1]
3. **Install kubeadm, kubelet, kubectl**:

```
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

Holding these packages prevents unintended upgrades that could cause version mismatch issues.[^2][^1]
4. **Disable swap (required by Kubernetes)**:

```
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

Kubernetes requires swap to be turned off for stability.[^2]
5. **Verify installation**:

```
kubeadm version
kubectl version
kubelet --version
```

These commands ensure that all tools are installed and recognized by your WSL environment.[^3]

### Additional Notes for WSL

- Kubernetes may require systemd to properly manage services like kubelet, which might need workarounds or scripts to operate on WSL since systemd is limited. There are scripts and guides available to enable systemd in WSL2 if needed.[^4][^3]
- Container runtime compatibility: Ensure Docker or containerd is properly installed and configured in your WSL instance before initializing the cluster.[^2]

This process will provide a working kubeadm installation on your WSL Ubuntu, with extra attention to potential special requirements for systemd, swap, and supported repositories in WSL.[^1][^3][^2]
<span style="display:none">[^5][^6][^7][^8]</span>

<div align="center">⁂</div>

[^1]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

[^2]: https://blog.nashtechglobal.com/how-to-install-kubernetes-on-ubuntu-20-04-kubeadm-and-minikube/

[^3]: https://gist.github.com/xynova/9014be71d6dcb19ae5e597a5cc3d6333

[^4]: https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/

[^5]: https://blog.devops.dev/build-k8s-cluster-on-wsl2-6ba82235b96a

[^6]: https://stackoverflow.com/questions/67760631/how-can-i-use-kubernetes-cluster-in-windows-wsl2

[^7]: https://ubuntu.com/kubernetes/install

[^8]: https://www.youtube.com/watch?v=GknbfLgCf0Q
