#!/bin/sh

firewall-cmd --permanent --add-port=5672/tcp
firewall-cmd --permanent --add-port=4369/tcp
firewall-cmd --permanent --add-port=35197/tcp
firewall-cmd --reload
setsebool -P nis_enabled 1
