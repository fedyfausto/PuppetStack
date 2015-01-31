#!/bin/sh

# Puppet install
cd
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
sudo yum install puppet

# Ruby1.9.3 and librarian-puppet install
#sudo apt-get -y install ruby1.9.3 build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev && gem install librarian-puppet --no-ri --no-rdoc

yum update
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel
yum install -y libyaml-devel libffi-devel openssl-devel make
yum install -y bzip2 autoconf automake libtool bison iconv-devel
curl -L get.rvm.io | bash -s stable
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
source /etc/profile.d/rvm.sh
rvm install 1.9.3
rvm use 1.9.3 --default
gem install librarian-puppet --no-ri --no-rdoc

# Puppet apply custom script
#sh ~/prisma/modules/puppet/files/papply.sh
