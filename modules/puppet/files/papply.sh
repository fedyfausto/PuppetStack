#!/bin/sh
sudo puppet apply ../prisma/manifests/ --modulepath=../prisma/modules/ $*
