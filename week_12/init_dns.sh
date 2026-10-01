#!/bin/bash
# Executes once on container boot to inject bad primary DNS
echo "nameserver 192.0.2.1" | cat - /etc/resolv.conf > /tmp/resolv.conf.tmp
cp /tmp/resolv.conf.tmp /etc/resolv.conf
rm /tmp/resolv.conf.tmp

