#!/bin/sh
PUPPETDIR=~/prisma
sudo /usr/bin/puppet apply --modulepath ${PUPPETDIR}/modules ${PUPPETDIR}/manifests $*
