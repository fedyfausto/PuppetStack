#!/bin/sh
PUPPETDIR=~/prisma
MAINDIR=/etc/puppet

#librarian-puppet setup
cd ${MAINDIR}
cp ${PUPPETDIR}/Puppetfile ${MAINDIR}/Puppetfile
rm -rf modules
librarian-puppet install

# Papply
sudo /usr/bin/puppet apply --modulepath ${PUPPETDIR}/modules:${MAINDIR}/modules --hiera_config=${PUPPETDIR}/hiera.yaml ${PUPPETDIR}/manifests/* $*
