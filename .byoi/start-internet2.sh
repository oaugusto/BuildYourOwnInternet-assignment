#!/bin/sh
set -eu

if [ $# -ne 1 ] ; then
    echo "usage: $0 <GROUPID>"
    exit 1
fi

BDIR=/root/.byoi/mininet-internet2/

pkill zebra || true
pkill ospfd || true
pkill bgpd || true
pkill ovs-controller >> /root/.byoi/ovs-controller.log 2>&1 || true
tmux kill-session -t mininext > /dev/null 2>&1 || true
sleep 0.5s
tmux new-session -d -s mininext
sleep 0.5s
tmux send -t mininext "sudo python $BDIR/start.py --cfgdir $BDIR/configs --topo $BDIR/configs/topology.txt --slash8 $1 --reset" ENTER
sleep 3s
