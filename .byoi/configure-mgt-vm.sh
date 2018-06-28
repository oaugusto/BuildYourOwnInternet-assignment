#!/bin/sh
set -eu
set -x

# Script used to create tunnels between VMs for eBGP peering.  This script
# needs to be run the the VM.

ebgp_interface_name=enp0s8

ip link set dev "$ebgp_interface_name" up
ip addr add "192.168.56.199/24" dev "$ebgp_interface_name" || true

ovs-vsctl del-br MGT || true
ovs-vsctl add-br MGT

ngroups=40

for i in $(seq "$ngroups") ; do
    echo "Configuring connection to AS$i"
    sysctl -w net.ipv4.ip_forward=0

    ip link del "g$i-ovs" type veth peer name "g$i" || true
    ip link add "g$i-ovs" type veth peer name "g$i"

    ip link set dev "g$i" up
    ip link set dev "g$i-ovs" up
    ip addr add "$i.0.199.2/24" dev "g$i" || true
    ip route add "$i.0.0.0/8" via "$i.0.199.1" || true
    ovs-vsctl add-port MGT "g$i-ovs" -- set interface "g$i-ovs" "ofport=$i"
    ovs-vsctl add-port MGT "gre_to_$i" -- set interface "gre_to_$i" type=gre options:remote_ip=192.168.56.$((100+$i))

    portin=$(ovs-ofctl show MGT | grep "\(g$i-ovs\)" | cut -f 1 -d '(' | tr -d ' ')
    portout=$(ovs-ofctl show MGT | grep "\(gre_to_$i\)" | cut -f 1 -d '(' | tr -d ' ')
    ovs-ofctl add-flow MGT in_port=$portin,actions=output:$portout
    ovs-ofctl add-flow MGT in_port=$portout,actions=output:$portin
done
