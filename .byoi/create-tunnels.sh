#!/bin/sh
set -eu

# Script used to create tunnels between VMs for eBGP peering.  This script
# needs to be run the the VM.

if [ $# -ne 2 ]; then
    echo "usage: $0 group-id as-connections"
    exit 1
fi

grpid=$1
connsfile=$2

ebgp_interface_name=enp0s8
ip=192.168.56.$(( 100 + grpid ))

# Configuring EBGP interface:
ip addr flush dev "$ebgp_interface_name"
ip addr add "$ip"/24 dev "$ebgp_interface_name"
ip link set dev "$ebgp_interface_name" up

while read -r _srctype _dsttype srcgrp dstgrp router _network ; do
    if [ "$srcgrp" != "$grpid" ] ; then continue ; fi
    dstip=192.168.56.$(( 100 + dstgrp ))
    iface=$(echo "$router" | tr '[:upper:]' '[:lower:]')
    ovs-vsctl add-port EBGPSW "gre_to_$dstgrp" -- set interface "gre_to_$dstgrp" type=gre "options:remote_ip=$dstip"
    portin=$(ovs-ofctl show EBGPSW | grep "($iface-ovs)" | cut -f 1 -d '(' | tr -d ' ')
    portout=$(ovs-ofctl show EBGPSW | grep "(gre_to_$dstgrp)" | cut -f 1 -d '(' | tr -d ' ')
    ovs-ofctl add-flow EBGPSW "in_port=$portin,actions=output:$portout"
    ovs-ofctl add-flow EBGPSW "in_port=$portout,actions=output:$portin"
done < "$connsfile"
