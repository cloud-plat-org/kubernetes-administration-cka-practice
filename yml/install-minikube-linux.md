# Minikube Installation Guide for CKA Training

This guide provides step-by-step instructions to install Minikube on Linux for CKA (Certified Kubernetes Administrator) training.

## Prerequisites

- Linux system (Ubuntu/Debian/CentOS/RHEL)
- At least 2GB RAM available for the VM
- Virtualization support enabled in BIOS
- Internet connection

## Step 1: Install a Hypervisor

Choose one of the following hypervisors:

### Option A: Install Docker (Recommended)
```bash
# Update package index
sudo apt update

# Create virtual environment for AWX CLI
python3 -m venv ~/awx-venv
source ~/awx-venv/bin/activate

# Install Docker
sudo apt install -y docker.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER
```

### Option B: Install VirtualBox
```bash
# Update package index
sudo apt update

# Install VirtualBox
sudo apt install -y virtualbox
```

### Option C: Install KVM2 (for systems with hardware virtualization)
```bash
# Install KVM and related packages
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Add your user to the docker group
sudo usermod -aG docker $USER

# Apply the group change to the current session
newgrp docker

# Verify you're now in the docker group
groups
```

## Step 2: Install kubectl

```bash
# Download the latest kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make kubectl executable
chmod +x kubectl

# Move kubectl to a directory in your PATH
sudo mv kubectl /usr/local/bin/

# Verify installation
kubectl version --client
```

## Step 3: Install Minikube

```bash
# Download Minikube binary
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Install Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify installation
minikube version
```

## Step 4: Start Minikube

### Using Docker driver (recommended)
```bash
# Start Minikube with Docker driver
minikube start --driver=docker

# Check cluster status
minikube status

# View cluster information
kubectl cluster-info
```

### Using VirtualBox driver
```bash
# Start Minikube with VirtualBox driver
minikube start --driver=virtualbox

# Check cluster status
minikube status
```

### Using KVM2 driver
```bash
# Start Minikube with KVM2 driver
minikube start --driver=kvm2

# Check cluster status
minikube status
```

## Step 5: Verify Installation

```bash
# Check Minikube status
minikube status

# View cluster nodes
kubectl get nodes

# View all pods in kube-system namespace
kubectl get pods -n kube-system

# Access Minikube dashboard (optional)
minikube dashboard
```

## Step 6: Configure kubectl Context

```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch to minikube context (if needed)
kubectl config use-context minikube
```

## Common Minikube Commands for CKA Training

```bash
# Start Minikube
minikube start

# Stop Minikube
minikube stop

# Delete Minikube cluster
minikube delete

# Get Minikube IP address
minikube ip

# SSH into Minikube VM
minikube ssh

# View Minikube logs
minikube logs

# Enable addons
minikube addons enable metrics-server
minikube addons enable dashboard

# List enabled addons
minikube addons list

# Set memory and CPU limits
minikube start --memory=4096 --cpus=2

# Load Docker images into Minikube
minikube image load <image-name>
```

## Troubleshooting

### Issue: Minikube fails to start
```bash
# Check system requirements
minikube start --driver=docker --alsologtostderr

# Reset Minikube
minikube delete
minikube start --driver=docker
```

### Issue: kubectl not found
```bash
# Check if kubectl is in PATH
which kubectl

# If not found, add /usr/local/bin to PATH
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
```

### Issue: Docker permission denied
```bash
# Add user to docker group and restart session
sudo usermod -aG docker $USER
newgrp docker

# Remove the large file from git tracking
git rm --cached minikube-linux-amd64

# Add it to .gitignore to prevent future commits
echo "minikube-linux-amd64" >> .gitignore

# Commit the changes
git add .gitignore
git commit -m "Remove minikube binary from tracking and add to .gitignore"

# Push the changes
git push
```

## CKA Training Tips

1. **Practice with different resources**: Create deployments, services, configmaps, secrets
2. **Use kubectl extensively**: Master kubectl commands and options
3. **Monitor resources**: Use `kubectl top` and `minikube dashboard`
4. **Practice networking**: Understand services, ingress, and network policies
5. **Work with storage**: Practice with persistent volumes and claims
6. **Security**: Practice with RBAC, security contexts, and network policies

## Next Steps

After successful installation:
1. Complete the [Kubernetes Basics Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
2. Practice with [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
3. Explore [CKA Exam Curriculum](https://github.com/cncf/curriculum)

## Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [CKA Exam Guide](https://www.cncf.io/certification/cka/)

```bash
# Remove VirtualBox and its dependencies
sudo apt remove --purge virtualbox virtualbox-*

# Remove any remaining configuration files
sudo apt autoremove --purge

# Clean up any leftover packages
sudo apt autoclean

# Verify VirtualBox is completely removed
dpkg -l | grep virtualbox

# Check if VirtualBox is still installed
which virtualbox

# Check for any VirtualBox processes
ps aux | grep virtualbox

# Check for VirtualBox kernel modules (should be empty)
lsmod | grep vbox


```