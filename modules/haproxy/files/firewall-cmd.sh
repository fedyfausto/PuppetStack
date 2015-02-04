#!/bin/sh
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=8080/tcp

firewall-cmd --permanent --zone=public --add-port=8/tcp
firewall-cmd --permanent --zone=public --add-port=112/tcp
firewall-cmd --reload
