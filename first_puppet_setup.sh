#!/bin/sh

# First puppet setup instructions
# Make sure you are in the project root (prisma-puppet)
# Ubuntu Precise 12.04
# 19/11/2014 - Alberto Di Savia Puglisi

# Puppet install
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb | wget resources/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get -y update && sudo apt-get -y install puppet

# Init Git repo with personal info
sudo apt-get -y install git 
git init
git config --global user.name "Alberto Di Savia Puglisi"
git config --global user.email "disalberto@gmail.com"

