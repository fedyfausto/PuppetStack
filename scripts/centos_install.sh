#!/bin/sh

# Puppet install
cd
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y update && yum -y install puppet

# Ruby and librarian-puppet install
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
yum -y install libyaml-devel libffi-devel openssl-devel make
yum -y install bzip2 autoconf automake libtool bison
gem install librarian-puppet --no-ri --no-rdoc

# Copy Project <-> Temporary Solution
cp -rd ~/prisma prisma.save
mv ~/prisma/environments/* /etc/puppet/environments/ && rm -rf ~/prisma/environments/
cp -rd ~/prisma/* /etc/puppet/ && rm -rf ~/prisma/

# Librarian Puppet install
cd /etc/puppet/ && rm -rf /modules
librarian-puppet install

# Puppet apply
/usr/bin/puppet apply --modulepath /etc/puppet/environments/test/modules:/etc/puppet/modules /etc/puppet/environments/test/manifests/nodes.pp $*
