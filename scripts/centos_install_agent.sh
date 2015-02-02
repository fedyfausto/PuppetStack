#!/bin/sh

# Puppet install
cd
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y update && yum -y install puppet

# Ruby and librarian-puppet install
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
yum -y install libyaml-devel libffi-devel openssl-devel make
yum -y install bzip2 autoconf automake libtool bison iconv-devel
gem install librarian-puppet --no-ri --no-rdoc

# Puppet apply custom script
sh ~/prisma/modules/puppet/files/papply.sh
