#!/bin/sh

# Puppet install
cd
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y update && yum -y install puppet

# Ruby1.9.3 and librarian-puppet install
yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel
yum -y install libyaml-devel libffi-devel openssl-devel make
yum -y install bzip2 autoconf automake libtool bison iconv-devel
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
rvm install 1.9.3
rvm use 1.9.3 --default
gem install librarian-puppet --no-ri --no-rdoc

# Puppet apply custom script
#sh ~/prisma/modules/puppet/files/papply.sh
