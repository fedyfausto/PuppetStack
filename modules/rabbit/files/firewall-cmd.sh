#!/bin/sh

firewall-cmd --permanent --add-port=5672/tcp
firewall-cmd --reload
setsebool -P nis_enabled 1
