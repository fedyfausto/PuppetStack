#!/bin/sh

# Puppet install
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb | wget resources/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get -y update && sudo apt-get -y install puppet
