#! /bin/bash

kubectl get all --all-namespaces -o yaml > all-namespaces.yaml
# VELERO Formerly known as Heptio Ark

# etcd version
etcdctl version # etcdctl version
kubectl -n kube-system describe pod etcd-controlplane | grep Image:
# get etcd listen addresses
kubectl describe pod etcd-controlplane -n kube-system | grep --listen-client-urls

# etct cluster backup (Always loacated on the master nodes)
etcd.service 
ectcdctl snapshot save snapshot.db \
    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    --cert /etc/kubernetes/pki/etcd/server.crt \
    --key /etc/kubernetes/pki/etcd/server.key   \
    --endpoints https://127.0.0.1:2379

etcdctl snapshot save /opt/snapshot-pre-boot.db \
    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    --cert /etc/kubernetes/pki/etcd/server.crt \
    --key /etc/kubernetes/pki/etcd/server.key   \
    --endpoints https://127.0.0.1:2379

ls -al /opt/
ls -al /opt/snapshot-pre-boot.db

ls -al /var/lib/etcd/
etcdutl snapshot status snapshot.db
etcdutl snapshot status /opt/snapshot-pre-boot.db

systemctl stop kube-apiserver

etcdutl snapshot restore snapshot.db --data-dir /var/lib/etcd-from-backup
etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir /var/lib/etcd-from-backup
ls -al /var/lib/etcd-from-backup

# OPTION 1: Update etcd manifest to point to new directory (Recommended for kubeadm)
# vim /etc/kubernetes/manifests/etcd.yaml
# Change: --data-dir=/var/lib/etcd  TO  --data-dir=/var/lib/etcd-from-backup
# Change: volumes.hostPath.path: /var/lib/etcd  TO  /var/lib/etcd-from-backup
# Save and wait for etcd pod to restart automatically

# OPTION 2: Replace the data directory (do this quickly to avoid auto-recreation)
# Backup old data
ls -al /var/lib/etcd
mv /var/lib/etcd /var/lib/etcd-old
# Move restored data to original location (must be immediate, before directory recreates)
ls -al /var/lib/etcd-from-backup
mv /var/lib/etcd-from-backup /var/lib/etcd
ls -al /var/lib/etcd
# If directory was recreated and nested: rm -rf /var/lib/etcd && mv /var/lib/etcd-from-backup /var/lib/etcd

etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir /var/lib/etcd-from-backup

etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir /var/lib/etcd-from-backup
2025-04-24T09:38:07Z    info    snapshot/v3_snapshot.go:265     restoring snapshot      {"path": "/opt/snapshot-pre-boot.db", "wal-dir": "/var/lib/etcd-from-backup/member/wal", "data-dir": "/var/lib/etcd-from-backup", "snap-dir": "/var/lib/etcd-from-backup/member/snap", "initial-memory-map-size": 10737418240}
2025-04-24T09:38:07Z    info    membership/store.go:141 Trimming membership information from the backend...
2025-04-24T09:38:07Z    info    membership/cluster.go:421       added member    {"cluster-id": "cdf818194e3a8c32", "local-member-id": "0", "added-peer-id": "8e9e05c52164694d", "added-peer-peer-urls": ["http://localhost:2380"]}
2025-04-24T09:38:07Z    info    snapshot/v3_snapshot.go:293     restored snapshot       {"path": "/opt/snapshot-pre-boot.db", "wal-dir": "/var/lib/etcd-from-backup/member/wal", "data-dir": "/var/lib/etcd-from-backup", "snap-dir": "/var/lib/etcd-from-backup/member/snap", "initial-memory-map-size": 10737418240}

vim /etc/kubernetes/manifests/etcd.yaml

# TROUBLESHOOTING: If etcd was already running before you moved the data
# Step 1: Verify etcd is using the correct data directory
kubectl describe pod etcd-controlplane -n kube-system | grep data-dir
# Should show: --data-dir=/var/lib/etcd

# Step 2: Force etcd to restart and pick up the restored data
# Stop etcd by moving the manifest
mv /etc/kubernetes/manifests/etcd.yaml /tmp/
# Wait for etcd to stop (check until it disappears)
crictl ps | grep etcd
# Move the manifest back to start etcd with the restored data
mv /tmp/etcd.yaml /etc/kubernetes/manifests/
# Watch for etcd to come back up
crictl ps | grep etcd

# Step 3: Verify the restart happened (should show RESTARTS: 1)
kubectl get pod etcd-controlplane -n kube-system
kubectl describe pod etcd-controlplane -n kube-system | tail -20

# Alternative: Force delete the pod if moving manifest didn't work
# kubectl delete pod etcd-controlplane -n kube-system --force --grace-period=0

# For non-kubeadm (systemd-managed etcd):
# systemctl daemon-reload
# systemctl restart etcd
# systemctl start kube-apiserver

# Step 4: Verify restored data
kubectl get deployments -A
kubectl get all -A
kubectl get deployments,services
kubectl get pods -A -o wide

# NOTE: If deployments don't appear, the backup was taken BEFORE they were created
# A backup only contains the cluster state from the time it was taken

kubectl get pods -n kube-system
k describe pod etcd-controlplane -n kube-system

k describe pod kube-apiserver-controlplane -n kube-system | grep apiserver.crt
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout









