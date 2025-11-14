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


















