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

sudo apt install net-tools
sudo apt install net-tools

## Switching 
ip link
ip link show
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
ping 8.8.8.8
ping 8.8.8.8




















