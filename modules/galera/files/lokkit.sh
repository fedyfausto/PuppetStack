#!/bin/sh
sudo lokkit --port 3306:tcp
sudo lokkit --port 4444:tcp
sudo lokkit --port 4567:tcp
sudo lokkit --port 4568:tcp
sudo service firewalld start
