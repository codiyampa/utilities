#!/bin/bash

SSH_IPS=$1
SSH_USER=$2
SSH_KEY_PATH=$3

###############################################################################
# Configuration script for CentOS 7
###############################################################################

# PRIVATE_NETWORK_IP=$1

###############################################################################
# Set up private network interface eth1
###############################################################################
# echo "Set up private network interface eth1.."

# cat > /tmp/ifcfg-eth1 <<EOF
# DEVICE=eth1
# ONBOOT=yes
# NM_CONTROLLED=no
# BOOTPROTO=static
# IPADDR=${PRIVATE_NETWORK_IP}
# NETMASK=255.255.240.0
# IPV6INIT=no
# MTU=1450
# EOF

# sudo cp /tmp/ifcfg-eth1 /etc/sysconfig/network-scripts/ifcfg-eth1

# ifup eth1

###############################################################################
# Configure firewall
###############################################################################
# firewall-cmd --permanent --add-port=7100/tcp
# firewall-cmd --permanent --add-port=9100/tcp
# firewall-cmd --permanent --add-port=9042/tcp
# firewall-cmd --permanent --add-port=7000/tcp
# firewall-cmd --permanent --add-port=9000/tcp
# firewall-cmd --reload

FIREWALL_RULES_CMD=""

for node in $SSH_IPS; do
	FIREWALL_RULES_CMD="${FIREWALL_RULES_CMD} firewall-cmd --permanent --zone=cluster --add-source=${node} ;"
done

for node in $SSH_IPS; do
  ssh -q -o "StrictHostKeyChecking no" -i "${SSH_KEY_PATH}" \
    "${SSH_USER}"@"${node}" "firewall-cmd --permanent --add-port=9042/tcp ; firewall-cmd --permanent --new-zone=cluster ; \
    firewall-cmd --permanent --zone=cluster --add-port=7100/tcp ; firewall-cmd --permanent --zone=cluster --add-port=9100/tcp ; ${FIREWALL_RULES_CMD} \
    firewall-cmd --reload;"
done