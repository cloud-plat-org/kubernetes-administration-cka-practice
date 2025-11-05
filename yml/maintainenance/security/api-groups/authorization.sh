# Why authorization is needed?

# Authorization mechanisms
# RBAC (Role Based Access Control)
# ABAC (Attribute Based Access Control)
# Webhook (Custom authorization logic)
# Node (Node authorization)
#   Node authorizer (group: system:node:<node-name>)
#   - Users
#   - kubelet
# this is accesss within the cluster

# ABAC (Attribute Based Access Control)
# dev-user
#   - view pods
#   - create pods
#   - delete pods
# policy file:
# /etc/kubernetes/abac-policy.yml
# These files have to be edited manually every time you want to add a new policy.

# RBAC (Role Based Access Control)
# create a role and assign users to the role
# role: developer
# role: security

# webhook (custom authorization logic)
# openpolicyagent (opa)
# user makes a request to the api server
# the api server uses a webhook to opa to check if the user has the necessary permissions
# opa then returns a decision to the api server
# the api server then allows or denies the request

# always allow and always deny
# -authorization-mode=node,rbac,webhook
# This works in the order listed.


# RBAC (deep dive)
# create a role and assign users to the role
kubectl create -f developer-role.yml
kubectl create -f devuser-development-binding.yml
kubectl get roles
kubectl get rolebindings
# These fall under the scope of the namespaces 
# namespace: default
kubectl describe role developer

