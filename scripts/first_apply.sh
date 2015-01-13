#!/bin/sh

# Puppet install
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb -P / | wget resources/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get -y update && sudo apt-get -y install puppet

# Ruby1.9.3 and librarian-puppet install
sudo apt-get -y install ruby1.9.3 ruby-dev build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev && gem install librarian-puppet

# Puppet apply custom script
sh ~/prisma/modules/puppet/files/papply.sh
