curl -k https://localhost:6443/version
curl -k https://localhost:6443/api/v1/namespaces/default/pods
/metrics # health check
/healthz # health check
/api # api server (core groups) *
/apis # api server (named groups) *
/logs # logs for third party integrations

# named
# groups
# resources
# verbs (GET, POST, PUT, DELETE, PATCH)


# GET List of API groups
curl -k https://localhost:6443 -k
curl -k https://localhost:6443/apis -k | grep name
kubectl proxy # So curl can be used without --cert path and --key path
# starts proxy port 8001 and uses the kubeconfig file
curl http://localhost:8001/api/v1/namespaces/default/pods
# instead of using the 
minikube start
curl -k https://127.0.0.1:32771 \
    --cert /home/dan_i/.minikube/profiles/minikube/client.crt \
    --key /home/dan_i/.minikube/profiles/minikube/client.key \
    --cacert /home/dan_i/.minikube/ca.crt
minikube stop

# kube-proxy is not equal to kubectl proxy

