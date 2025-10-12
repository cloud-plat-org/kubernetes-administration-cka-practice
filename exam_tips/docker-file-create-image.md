Those lines look like they're meant to represent a container specification. Let me show you how to use them:

## Option 1: Create a Dockerfile and build a Docker image

**Create a Dockerfile:**
```dockerfile
FROM ubuntu
CMD ["sleep", "5"]
```

**Build and run:**
```bash
# Create the Dockerfile
cat > Dockerfile << EOF
FROM ubuntu
CMD ["sleep", "5"]
EOF

# Build the image
docker build -t my-ubuntu-sleep .

# Run the container
docker run my-ubuntu-sleep
```

## Option 2: Create a Kubernetes Pod (more relevant for CKA)

If you want to create a Kubernetes pod with this container specification:

**Using kubectl run (imperative):**
```bash
kubectl run my-pod --image=ubuntu --command -- sleep 5
```

**Using YAML (declarative):**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: ubuntu-container
    image: ubuntu
    command: ["sleep", "5"]
```

**Create from YAML:**
```bash
kubectl apply -f pod.yaml
```

**Note:** The syntax in your file should be:
- `FROM` (not `From:`) for Dockerfile
- `CMD ["sleep", "5"]` or `CMD sleep 5` for Dockerfile
- `command: ["sleep", "5"]` for Kubernetes YAML

Would you like me to help you correct the syntax in your `imparitive_commands.sh` file, or create example files for either approach?