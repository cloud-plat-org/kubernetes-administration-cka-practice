




kubectl apply -f yml/redis-service.yml
kubectl apply -f yml/nginx-deployment.yml
kubectl apply -f yml/nginx-service.yml
kubectl apply -f yml/webapp-deployment.yml
kubectl apply -f yml/webapp-service.yml
kubectl apply -f yml/webapp-ingress.yml
kubectl apply -f yml/webapp-ingress.yml


## Environment Variables
#
# Plain Key Value Pairs
# ConfigMaps
# Secrets

# Declaritive:
kubectl create -f yml/config-map.yml