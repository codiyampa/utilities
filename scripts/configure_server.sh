#!/bin/bash

###############################################################################
# Configuration script for CentOS 7
###############################################################################

PRIVATE_NETWORK_IP=$1

###############################################################################
# Set up private network interface eth1
###############################################################################
echo "Set up private network interface eth1.."

cat > /tmp/ifcfg-eth1 <<EOF
DEVICE=eth1
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=${PRIVATE_NETWORK_IP}
NETMASK=255.255.240.0
IPV6INIT=no
MTU=1450
EOF

sudo cp /tmp/ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1

ifup eth1

###############################################################################
# Configure firewall
###############################################################################
firewall-cmd --permanent --add-port=7100/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --permanent --add-port=9000/tcp
firewall-cmd --permanent --add-port=7000/tcp
firewall-cmd --permanent --add-port=9042/tcp
firewall-cmd --reload