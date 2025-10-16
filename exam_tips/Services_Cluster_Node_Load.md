In Kubernetes, there are **three primary types of Services** — **ClusterIP**, **NodePort**, and **LoadBalancer** — each providing different levels of accessibility for connecting applications and exposing workloads.[^1][^3][^5]

### **1. ClusterIP (default)**

- Exposes a Service **only inside the cluster** using an internal virtual IP.
- Used for **Pod-to-Pod communication** (for example, between microservices).
- Ideal for internal services like databases, caches, or APIs only consumed by other cluster resources.[^5][^1]


### **2. NodePort**

- Exposes a Service on a specific port (between 30000–32767) on **each node’s IP**.

```
- Allows **external access** by connecting to `<NodeIP>:<NodePort>`.  
```

- Suitable for **development, testing, or direct node access** without load balancing.[^2][^8]


### **3. LoadBalancer**

- Provisions an **external load balancer** from the cloud provider (e.g., AWS ELB, Azure LB).
- Directs external traffic to the NodePorts behind it, providing **one stable public IP**.
- Common in **production** for high availability and automatic traffic distribution across pods and nodes.[^6][^1][^5]

All three build on each other—**LoadBalancer** uses **NodePort**, which in turn uses **ClusterIP**—ensuring flexibility from internal-only access to cloud-scale public exposure.[^3][^8]
<span style="display:none">[^4][^7][^9]</span>

<div align="center">⁂</div>

[^1]: https://kodekloud.com/blog/clusterip-nodeport-loadbalancer/

[^2]: https://octopus.com/blog/difference-clusterip-nodeport-loadbalancer-kubernetes

[^3]: https://kubernetes.io/docs/concepts/services-networking/service/

[^4]: https://www.sysdig.com/blog/kubernetes-services-clusterip-nodeport-loadbalancer

[^5]: https://www.geeksforgeeks.org/devops/kubernetes-cluster-ip-vs-node-port/

[^6]: https://edgedelta.com/company/blog/kubernetes-services-types

[^7]: https://spacelift.io/blog/kubernetes-service

[^8]: https://stackoverflow.com/questions/41509439/difference-between-clusterip-nodeport-and-loadbalancer-service-types-in-kuberne

[^9]: https://www.youtube.com/watch?v=T4Z7visMM4E

