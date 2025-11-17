#! /bin/bash

kubectl apply -f yml/networking/networking.yml

# Networking Prerequisites
# * Switching and Routing
#  - Switching
#  - Routing
#  - Default Gateway
# * DNS
#  - DNS Configuration on Linux
#  - CoreDNS Instructions
# * Network Namespaces
# * Docker Networking

ip link
ip addr 
ip addr add 192.168.1.100/24 eth0
# if persistent must be set in /etc/network/interfaces file.
ip route or route # show routes
ip route add 192.168.2.0/24 via 192.168.1.1 dev eth0
cat /proc/sys/net/ipv4/ip_forward # 0 - disabled, 1 - enabled





sudo apt install net-tools
sudo apt install net-tools

## Switching 
ip link
ip link show
ip link set eth0 up
ip link show eth0
ip addr add 192.168.1.100/24 dev eth0  # add IP to eth0 interface
ip addr show eth0
# host 1 192.168.1.100
# Switch 192.168.1.0
# host 2 192.168.1.101
ping 192.168.1.101 # from host 1 to host 2

# antoher network: 192.168.2.100/24
ip addr add 192.168.2.100/24 dev eth0
ip addr show eth0
# host 21 192.168.2.100
# Switch 192.168.2.0
# host 22 192.168.2.101
ping 192.168.2.100 # from host 21 to host 22

# to connect the two networks you need a router
# router connects to a port on the switch for each network
# the router will have two IP addresses:
#  - 192.168.1.1 (for network 1)
#  - 192.168.2.1 (for network 2)

route
# This first part is not preferred (static routing), default gateway is preferred
# default gateway is the IP address of the router
ip route add 192.168.2.0/24 via 192.168.1.1 dev eth0 (network 1 to network 2)
# traffic on network 1 goes through 192.168.1.1 to any IP address in network 2
ip route show
ip route add 192.168.1.0/24 via 192.168.2.1 dev eth0 (network 2 to network 1)
# traffic on network 2 goes through 192.168.2.1 to any IP address in network 1
ip route show
# these routes need to be added to every host on each network to access the other network
# if you want access to the internet you need to add a default gateway to the host
ip route add default via 192.168.1.1 dev eth0
ip route show
ip route add default via 192.168.2.1 dev eth0
ip route show
# now you can access the internet from any host on either network 
# and access the other network
ping 8.8.8.8
ping 192.168.2.100 # from host 1 to host 22
# if multiple routers you may need have one route to each router
# if one is the internet router, you may need to add a default gateway to the host

### How to setup a Linux host as a router ###

# host A
# eth0: 192.168.1.0
# host IP: 192.168.1.5

# host B
# eth0: 192.168.1.0
# eth1: 192.168.2.0
# 2 hosts IP's 192.168.1.6 and 192.168.2.6


# host C
# eth0: 192.168.2.0
# host IP: 192.168.2.5

ping 192.16.2.5 from host A to host C
# Conntect: network unreachable

# on host A we need to add a route:
ip route add 192.168.2.0/24 via 192.168.1.6
# on host C we need:
ip route add 192.168.1.0/24 via 192.168.2.6

# Now if we ping 192.16.2.5 from host A to host C
# we still won't be able to connect
# Because host B by default will not forward traffic from one interface to the other
cat /porc/sys/net/ipv4/ip_forward
# 0 - disabled
# 1 - enabled
echo 1 > /proc/sys/net/ipv4/ip_forward # not persistent

# Now if we ping 192.16.2.5 from host A to host C
# we should be able to connect
ping 192.16.2.5

# If we want to permanently enable IP forwarding, 
# we can add the following to /etc/sysctl.conf:
# net.ipv4.ip_forward = 1 
# and then run:
sysctl -p

### DNS ###

cat /etc/hosts  # this is where names can be mapped to IP addresses
# 192.168.1.11      db
# 192.168.2.11      www.google.com # Spoofing is possible here.
hostname
# host2 #This doesn't matter to host with mapping in /etc/hosts.

# Instead of using /etc/hosts, we can use DNS servers.

cat /etc/resolv.conf # this is where DNS servers are configured
# can have multiple servers, order matters.

# /etc/hosts had precedence over DNS servers.
cat /etc/nsswitch.conf # this is where the order of name service is configured
# hosts:          files dns
# This means that the system will first look in /etc/hosts for the name,
# and then in the DNS servers.
 
# www.kubernetes.io is a domain name
# These are the top level domains (TLDs)
.com (Commercial)
    www.google.com 
    www.youtube.com
.net (Network)
    www.behance.net
    www.speedtest.net   
.edu (Education)
    www.stanford.edu
    www.harvard.edu
.org (Organization)
    www.wikipedia.org
    www.wikimedia.org
.io
    www.kubernetes.io

# root .
# .com Is top level domain (TLD)
# google (is the name assigned to the company Google Inc.)
# www  is a subdomain of .com ( maps, drives, apps, mail,etc.)

# apps.google.com
#     ^
# Org DNS (my company's DNS)
#     ^
# Root DNS (.)
#     ^
# .com DNS
#     ^
# Google DNS
#     ^
# 216.58.221.78 # Google's IP address
# An Organization's DNS server my cache the DNS records for a limited time.

# ORG DNS (my company's DNS)
# mycompany.com
# www, mail, hr, pay, drives, etc.
cat /etc/resolv.conf
# our internal DNS server is 192.168.1.11
# With this it is manditory to use the full domain name for internal resources.
# mail.mycompany.com
# drives.mycompany.com
# db.mycompany.com
# If you use the short name, you will not be able to access the internal resources.
# if you want to use short names ass a search entry in /etc/hosts or /etc/resolv.conf
search mycompany.com
# now if you just type mail, it will be resolved to mail.mycompany.com
search     mycompany.com     prod.mycompany.com
# order matters, the first one will be used.

### DSN Record Types ###
# A record - maps a domain name to an IP address
# AAAA record - maps a domain name to an IPv6 address
# CNAME record - maps a domain name to another domain name

sudo apt install bind9-dnsutils -y # for nslookup and dig
sudo apt install bind9-host -y # for host command
nslookup www.google.com
dig www.google.com
host www.google.com


#### Network Namespaces ####

Namespaces (Network Isolation)
ps aux # On the container
ps aux # On the host

# Host
  # eth0: 192.168.1.0
  # Routing table:
  # ARP Table:

# container
  # veth0: 192.168.1.100
  # Routing table:
  # ARP Table:

# Create namespaces
ip netns add red
ip netns add blue

# List namespaces
ip netns

# list interfaces on host
ip link
arp
# how do I see this on the namespace?
ip netns exec red ip link
ip -n red link
ip -n blue link

ip netns exec red arp
ip netns exec blue arp

ip netns exec red route
ip netns exec blue route

# how do we connect the namespaces?
ip link add veth-red type veth peer name veth-blue
ip link set veth-red netns red
ip link set veth-blue netns blue
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
ip -n red link set veth-red up
ip -n red link delete veth-red # When one side is deleted, the other side is deleted.
ip -n blue link set veth-blue up
ip -n blue link delete veth-blue # When one side is deleted, the other side is deleted.
ip netns exec red arp
# should see the ARP entry for the other namespace
ip netns exec blue arp
# should see the ARP entry for the other namespace
arp 
# On host, you won't see the arp for the other namespace

ip netns exec red ping 192.168.15.2
ip netns exec blue ping 192.168.15.1

# Switch is needed for multiple namespaces to communicate with each other.
# Linux Bridge is a virtual switch that can be used to connect the namespaces.
# Open vSwitch is a virtual switch that can be used to connect the namespaces.

# to create a switch we need a new interface on the host
ip link add v-net-0 type bridge
ip link set v-net-0 up
ip link
# this is an internal interface on the host, being used as a switch
ip addr add 192.168.15.1/24 dev v-net-0
ip addr show v-net-0
# now we can connect all the namespaces to the switch

# These are the cables only, we need to connect the namespaces to the switch.
ip link add veth-red type veth peer name veth-red-br
ip link set veth-blue type veth peer name veth-blue-br
#  This connects the one end of the cable to the namespace.
ip link set veth-red netns red
ip link set veth-blue netns blue
# This connects the other end of the cable to the switch.
ip link set veth-red-br master v-net-0
ip link set veth-blue-br master v-net-0
# add IP to the switch
ip addr add 192.168.15.1/24 dev v-net-0
ip addr show v-net-0
# add IP to the namespaces
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
ip -n red addr show veth-red
ip -n blue addr show veth-blue
# bring up the cables
ip link set veth-red-br up
ip link set veth-blue-br up

# what if I try to reach one of namespace ip's from the host?
ping 192.168.15.1
# this will not work because it is on a different network.
ip add add 192.168.15.5/24 dev v-net-0
ip addr show v-net-0
ping 192.168.15.1
# this will work because it is on the same network.
# This network is still private on the host, can not reach from the internet.
ip netns exec blue ping 192.168.1.3 # from namespace blue to outside network
# this will not work because it is on a different network.
ip netns exec blue route
# add a route to the outside network
ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5 veth-blue
# This connect the namespace to the outside network.
ping 192.168.1.2 or ping 192.168.1.3
# this will not work because the ouside network doent know about the namespace network.
# NAT is needed 
iptable -t nat PREROUTING -s 192.168.15.0/24 -j MASQUERADE
# This will masqerade the namespace network to the outside network.
# This adds the host interal network ip to the packet so outside network knows about the namespace network.
    # View all NAT table rules
    iptables -t nat -L -n -v
    # View only PREROUTING chain
    iptables -t nat -L PREROUTING -n -v
    # More detailed with line numbers
iptables -t nat -L PREROUTING -n -v --line-numbers
ping 192.168.1.2 or ping 192.168.1.3
# this will work because the outside network knows about the namespace network.

# next we try to ping the internet from the namespace network
ip netns exec blue ping 8.8.8.8
# this will not work because the namespace network is not connected to the internet.
# we need to add a default gateway to the namespace network.
ip netns exec blue ip route add default via 192.168.15.5 ???veth-blue???
# This adds a default gateway to the namespace network.
ping 8.8.8.8
# this will work because the namespace network is connected to the internet.

iptables -t nat -A PREROUTING --dport 80 --to-destination 192.168.15.2:80 -j DNAT 
# This will redirect the traffic to the namespace network.

# FAQ
# While testing the Network Namespaces, if you come across issues 
# where you can't ping one namespace from the other, make sure you 
# set the NETMASK while setting IP Address. ie: 192.168.1.10/24

# ip -n red addr add 192.168.1.10/24 dev veth-red

# Another thing to check is FirewallD/IP Table rules. 
# Either add rules to IP Tables to allow traffic from one 
# namespace to another. Or disable IP Tables all together 
# fd(Only in a learning environment).

### Docker Networking ###

# A host with docker, and eth0 192.16.1.10
docker run --network none nginx
# this is the none network, not attached to any network.
# When a container is created, it has no network access.
docker run --network host nginx
# this is the host network, the container is attached to the host network.
# 192.168.1.10:80 -> 192.168.1.10:80
# this will only work for one container.

# bridge network #
docker network ls
# name: bridge
ip link
# docker0
# it assigns an IP address to the bridge 172.17.0.1/24 

ip link add docker0 type bridge

docker run nginx
# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
# 1234567890     nginx     "nginx"   10 seconds ago   Up 8 seconds   0.0.0.0:80->80/tcp   nginx

ip netns
# 4938883

docker inspect 4938883
# "NetworkSettings": {
#     "Networks": {
#         "bridge": {
#             "IPAMConfig": null,
#             "Links": null,
#             "IPAddress": "172.17.0.2",
#             "IPPrefixLen": 16,
#             "Gateway": "172.17.0.1",
#             "GlobalIPv6Address": "",
#             "GlobalIPv6PrefixLen": 0,
#             "MacAddress": "02:42:ac:11:00:02"
#         }
#     }
# }

## Container and network namespace means the same thing.

# How does docker connect the container to the bridge?
# Docker creates a virutual cable with two interfaces on each end.
ip link
# master docker0 veth*, this is the connection to the bridge.
ip -n 4938883 link
# eth0@if9
# This is the connection to the container.
io -n 4938883 addr show eth0@if9
# 172.17.0.2/16

ip addr show eth0@if9
# 172.17.0.2/16
ip addr show docker0
# 172.17.0.1/16
ping 172.17.0.1
# this will ping the bridge.
ping 172.17.0.2

# every time a container is created, docker creates a new namespace, two interfaces, 
# a virutual cable with two interfaces on each end.
# These interfaces are called veth pairs.
# Pairs can be idetified by the odd and even numbers. 9 & 10, 11 & 12, etc.
# The odd number is the connection to the container.
# The even number is the connection to the bridge.
docker run nginx
# 1234567890, Port 80, This can only be accessed from the private network on the host.
# From within the host:
# curl 172.17.0.3:80 
# Welcome to the container.
# From outside the host:
curl http://172.17.0.3:80 
# fails because the container is not accessible from the outside world.

docker run -p 8080:80 nginx
# 1234567890, Port 80, This can be accessed from the outside world.
curl http://172.17.0.3:8080 
# Welcome to the container.

# How does connect port 8080 (external port) to port 80 (internal port)?
# Docker creates a new iptables rule to redirect the traffic from the external port to the internal port.
iptables -t nat -A PREROUTING --dport 8080 --to-destination 172.17.0.3:80 -j DNAT
# This will redirect the traffic from the external port to the internal port.
# docker does it the same way. It adds the rule to the docker chain.
# notice that when docker does this it includes the container ip address in the rule.
iptables -t nat -L -n -v
# DNAT tcp  -- anywhere anywhere tcp dpt:8080 to:172.17.0.3:80

# CONTAINER NETWORK INTERFACE CNI #
    ## Network Namespaces
    # Create network namespace for the container
    # Create interface for the container
    # Create virtual cable for the container
    # Attach the veth to the namespace
    # Attach the veth to the bridge
    # Add IP address to the interface
    # Bring up the interface
    # Enable NAT-IP MASQUERADE

    ## docker bridge network (Same as Network Namespaces different commands)
    # Create network namespace
    # Create bridge network/interface
    # Creat veth pairs
    # Attach the veth to the namespace
    # Attach the veth to the bridge
    # Assign IP addresses
    # Bring up the interfaces
    # Enable NAT-IP MASQUERADE

    # rkt and Meso's also use this method.
    ## Kubernetes also uses this method.

# Since these are the same, we moved away from this to Bride:
## Bridge ##
bridge add <container-id> /var/run/docker/netns/<container-id>
# the bridge program takes care of the rest of the steps.
# When rkt or kubernetes creates a new container, it runs the bridge program.
bridge add <cid> <namespace>
# What is I wanted to create my own program to create a new container?
# This is where CNI comes in.
# CNI is a standard for container networking.
# CNI plugins are available for different network providers.

# Container Runtime must create network namespace
# Identify the network the container must attach to.
# Container Runtime to invoke Network Plugin (bridge) when the container is created.
# Container Runtime to invoke Network Plugin (bridge) when the container is deleted.
# JSON format for the network configuration.
# ----------------------------------
# ON the plugin side:
# Must support command line arguments ADD, DEL, CHECK
# Must support parameters container id, network ns, etc.
# Must manage IP address assigned to pods
# Must return results in a specific format

# Standard plugins:
# BRIDGE
# VLAN
# IPVLAN
# MACVLAN
# WINDOWS
    # host-local
    # DHCP
# there are other plugins too:
# flannel
# cilium
# NSX
# calico
# etc.
# All of these adhere to the CNI standard.

# Docker:
# Container Netwwork Model (CNM) simular to CNI but different.
# The above plugins don't easily work with docker.
# X docker run --network=cni-bridge nginx, fails because docker doesn't know about the plugin.
# This is how Kubernetes creates a new container.
docker run --network=none nginx
bridge add 3948938 /var/run/docker/netns/3948938

### Networking Cluster Nodes ###

# master-01
# 192.168.1.10
# MAC Address: 02:42:ac:11:00:02
# eth0: 192.168.1.10
# kube-apiserver port 6443
# kube-scheduler port 10251 (to kube-api 6443)
# kube-scheduler port 10259 (for direct access to kube-scheduler)
# kube-controller-manager port 10252 (to kube-api 6443)
# kube-controller-manager port 10257 (for direct access to kube-controller-manager)
# etcd port 2379 (for direct access to etcd)
# etcd peer communication (between etcd nodes): 2380.​
# etcd client communication (API server or etcdctl): 2379.​
# https://kubernetes.io/docs/reference/networking/ports-and-protocols/

# worker-01
# 192.168.1.11
# MAC Address: 02:42:ac:11:00:03
# eth0: 192.168.1.11
# kubelet (kube-api) port 6443
# kubelet port 10250, for direct access to kubelet.
# services ports 30000-32767

# worker-02
# 192.168.1.12
# MAC Address: 02:42:ac:11:00:04
# eth0: 192.168.1.12
# kubelet (kube-api) port 6443
# kubelet port 10250, for direct access to kubelet.
# services ports 30000-32767

# Network:
# 192.168.1.0

###########  COMMANDS to keep handy for LAB ###########
ip link
ip addr add 192.168.1.10/24 dev eth0
ip addr
ip route add 192.168.1.0/24 via 192.168.2.1
ip route
netstat -plnt
arp
route
cat /proc/sys/net/ipv4/ip_forward

kubectl get nodes 
kubectl get nodes -o wide
ip addresss # look for nic with same IP as -o wide output

ip address show type bridge # look for bridge interface
# test for bridge interface:
ip link | grep cni

ip route # default gateway
route 

netstat --help
netstat -npl | grep -i scheduler

netstat -a | grep 2379 | wc -l
# 130
netstat -a | grep 2380 | wc -l
# 1
# better way to test:
netstat -npa | grep -i etcd | grep -i 2379 | wc -l
netstat -npa | grep -i etcd | grep -i 2380 | wc -l


### POD Networking Concepts ###











