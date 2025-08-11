#!/bin/bash
iptables -F # Flush all rules
iptables -P INPUT DROP # Drop all incoming traffic
iptables -P FORWARD DROP # Drop all forwarded traffic
iptables -P OUTPUT ACCEPT # Allow all outgoing traffic
iptables -A INPUT -p tcp --dport 80 -j ACCEPT # Allow HTTP traffic on port 80

