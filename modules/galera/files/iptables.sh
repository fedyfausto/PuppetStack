#!/bin/sh
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 4444 -j ACCEPT
iptables -A INPUT -p tcp --dport 4567 -j ACCEPT
iptables -A INPUT -p tcp --dport 4568 -j ACCEPT
