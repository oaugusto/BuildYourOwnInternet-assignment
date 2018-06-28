#!/usr/bin/env python

import argparse
import atexit
import errno
import os
import sys
import resource

from collections import defaultdict

import mininet.cli
import mininet.log
import mininet.topo
import mininet.util

from mininet.log import info
from mininet.net import Mininet
from mininet.node import OVSController

mininet_network = None


class Internet2Topo(mininet.topo.Topo):  # {{{
    def build(self, rtr2rtr2net, opts):  # pylint: disable=W0221
        info('  Creating switch to interconnect networks\n')
        switch = self.addSwitch('EBGPSW', dpid='1')

        for rtr in rtr2rtr2net:
            hostname = '%s-host' % rtr
            info('  Creating %s and %s\n' % (rtr, hostname))
            cfgdir = os.path.join(opts.cfgdir, rtr)
            self.addNode(name=rtr, hostname=rtr, ip=None, 
                    privateDirs=['/run/quagga', ('/etc/quagga', cfgdir)])
            self.addNode(name=hostname, hostname=hostname, ip=None)

        for rtr, rtr2net in rtr2rtr2net.items():
            hostname = '%s-host' % rtr
            for neigh in rtr2net:
                if rtr > neigh: continue
                info('  Creating link %s-%s\n' % (rtr, neigh))
                self.addLink(rtr, neigh,
                             intfName1=neigh.lower(), intfName2=rtr.lower())
            info('  Creating link from %s to host\n' % rtr)
            self.addLink(rtr, hostname,
                         intfName1='host', intfName2=rtr.lower())

            if2 = '%s-ovs' % rtr.lower()
            self.addLink(rtr, switch, intfName1='ebgp', intfName2=if2)

        info('  Creating management interface on HOUS\n')
        self.addLink('HOUS', switch, intfName1='mgt',
                     intfName2='hous-mgt-ovs')
# }}}


def start_network(rtr2rtr2net, rtr2lo, opts):  # {{{
    topo = Internet2Topo(rtr2rtr2net, opts)
    info('Starting the network\n')
    global mininet_network
    mininet_network = Mininet(topo=topo, controller=OVSController)
    mininet_network.start()

    info('  Configuring interfaces\n')

    info('  Starting Quagga daemons\n')
    for rtr in rtr2lo:
        name = 'G%d_%s' % (opts.slash8, rtr)
        zebra = '/usr/sbin/zebra -f %s -i %s --daemon -A 127.0.0.1 -P 2601 > %s 2>&1' % (
                os.path.join(opts.cfgdir, rtr, 'zebra.conf'),
                os.path.join('/root', 'logs', 'zebra_%s.pid' % name),
                os.path.join('/root', 'logs', 'zebra_%s.out' % name))
        ospfd = '/usr/sbin/ospfd -f %s -i %s --daemon -A 127.0.0.1 -P 2604 > %s 2>&1' % (
                os.path.join(opts.cfgdir, rtr, 'ospfd.conf'),
                os.path.join('/root', 'logs', 'ospfd_%s.pid' % name),
                os.path.join('/root', 'logs', 'ospfd_%s.out' % name))
        bgpd = '/usr/sbin/bgpd -f %s -i %s --daemon -A 127.0.0.1 -P 2605 > %s 2>&1' % (
                os.path.join(opts.cfgdir, rtr, 'bgpd.conf'),
                os.path.join('/root', 'logs', 'bgpd_%s.pid' % name),
                os.path.join('/root', 'logs', 'bgpd_%s.out' % name))
        info('%s\n%s\n%s\n' % (zebra, ospfd, bgpd))
        mininet_network[rtr].cmd('chown quagga:quagga /run/quagga')
        mininet_network[rtr].cmd('chmod 700 /run/quagga')
        mininet_network[rtr].cmd(zebra)
        mininet_network[rtr].waitOutput()
        mininet_network[rtr].cmd(ospfd)
        mininet_network[rtr].waitOutput()
        mininet_network[rtr].cmd(bgpd)
        mininet_network[rtr].waitOutput()

    info('  Connections\n')
    mininet.util.dumpNodeConnections(mininet_network.hosts)

    mininet.cli.CLI(mininet_network)
# }}}


def stop_network():  # {{{
    os.system('pkill zebra')
    os.system('pkill ospfd')
    os.system('pkill bgpd')
    if mininet_network is not None:
        info('Tearing down Mininet network\n')
        mininet_network.stop()
# }}}


def read_topology(opts):  # {{{
    rtr2lo = dict()
    rtr2rtr2net = defaultdict(dict)
    with open(opts.topofn) as fd:
        for line in fd:
            if line[0] == '#':
                continue
            line = line.replace('__SLASH8__', str(opts.slash8))
            src, dst, net, loopback, _ospfcost = line.split()
            rtr2lo[src] = loopback
            rtr2rtr2net[src][dst] = net
    return rtr2rtr2net, rtr2lo
# }}}


def write_quagga_configs(rtr2lo, opts):  # {{{
    info('  Writing Quagga configs to %s\n' % opts.cfgdir)
    try:
        os.makedirs(os.path.join('/root', 'logs'))
    except OSError as e:
        if e.errno != errno.EEXIST: raise
    os.system('chown quagga:quagga /root/logs')
    for rtr in rtr2lo:
        try:
            os.makedirs(os.path.join(opts.cfgdir, rtr))
        except OSError as e:
            if e.errno != errno.EEXIST: raise
        for fn in ['zebra.conf', 'ospfd.conf', 'bgpd.conf', 'vtysh.conf']:
            with open(os.path.join(opts.cfgdir, 'template', fn)) as infd:
                template = infd.read()
                template = template.replace('NAME',
                                            'G%d_%s' % (opts.slash8, rtr))
                template = template.replace('BASEDIR', opts.cfgdir)
                template = template.replace('127.0.0.1', rtr2lo[rtr])
            with open(os.path.join(opts.cfgdir, rtr, fn), 'w') as outfd:
                outfd.write(template)
    os.system('chown quagga:quagga -R %s' % opts.cfgdir)
# }}}


def create_parser(): # {{{
    desc = '''Create the Internet2 topology using Mininet'''
    parser = argparse.ArgumentParser(description=desc)

    parser.add_argument('--topo',
            dest='topofn',
            metavar='FILE',
            type=str,
            help='File specifying the network topology.  linefmt="src dst net src-loopback"')

    parser.add_argument('--slash8',
            dest='slash8',
            metavar='OCTET',
            type=int,
            required=True,
            help='The /8 prefix to use on subnetworks')

    parser.add_argument('--cfgdir',
            dest='cfgdir',
            metavar='DIR',
            type=str,
            required=True,
            help='Base directory where configs will be created')

    parser.add_argument('--reset',
            dest='reset',
            action='store_true',
            default=False,
            help='Reset Quagga configurations to their defaults [%(default)s]')

    return parser
# }}}


def main():  # {{{
    resource.setrlimit(resource.RLIMIT_AS, (1 << 30, 1 << 30))
    resource.setrlimit(resource.RLIMIT_FSIZE, (1 << 35, 1 << 35))

    parser = create_parser()
    opts = parser.parse_args()

    rtr2rtr2net, rtr2lo = read_topology(opts)
    if opts.reset:
        write_quagga_configs(rtr2lo, opts)

    atexit.register(stop_network)

    mininet.log.setLogLevel('info')
    start_network(rtr2rtr2net, rtr2lo, opts)
# }}}


if __name__ == '__main__':
    sys.exit(main())
