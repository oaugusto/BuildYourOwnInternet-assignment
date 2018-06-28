#!/bin/sh
set -eu

die () {
    echo "$1"
    exit "$2"
}

if [ $# -lt 1 ] ; then
    die "usage: $0 <NODE> [CMD]" 1
fi

host=$1

# echo $1 > /root/.prompt

pid=$(pgrep -f "^bash.*mininet:${host}$" || true)

if echo "$pid" | grep -q ' '; then
  die "Error: found multiple mininet:$host processes" 2
fi

if [ -z "$pid" ] ; then
    die "Could not find Mininet host $host" 3
fi

export ROUTER=$1

cmd=bash
if [ $# -gt 1 ] ; then
    shift
    cmd=$*
fi

exec mnexec -a "$pid" $cmd
