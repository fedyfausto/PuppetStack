#!/bin/sh
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=8080/tcp

firewall-cmd --permanent --zone=public --add-port=5000/tcp
firewall-cmd --permanent --zone=public --add-port=35357/tcp

firewall-cmd --permanent --zone=public --add-port=9292/tcp
firewall-cmd --permanent --zone=public --add-port=9191/tcp

firewall-cmd --permanent --zone=public --add-port=8773/tcp
firewall-cmd --permanent --zone=public --add-port=8774/tcp
firewall-cmd --permanent --zone=public --add-port=8775/tcp

firewall-cmd --permanent --zone=public --add-port=9696/tcp

firewall-cmd --permanent --zone=public --add-port=6080/tcp

#firewall-cmd --permanent --zone=public --add-port=8/tcp
#firewall-cmd --permanent --add-port=112/tcp
firewall-cmd --reload
