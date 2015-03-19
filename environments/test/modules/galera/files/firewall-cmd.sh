#!/bin/sh
firewall-cmd --permanent --add-port=4567-4568/tcp
firewall-cmd --permanent --add-port=4444/tcp
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload
