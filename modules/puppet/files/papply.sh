#!/bin/sh
PUPPETDIR=~/prisma
MAINDIR=/etc/puppet
sudo /usr/bin/puppet apply --modulepath ${PUPPETDIR}/modules:${MAINDIR}/modules ${PUPPETDIR}/manifests/* $*
