#!/bin/bash

cd /root || exit

move()
{
  mv -v --backup=t -f ".apt-show-versions.$1" ".apt-show-versions.$2"
}

[ .apt-show-versions.out -nt /var/cache/apt/pkgcache.bin ] || move out old
[ -s .apt-show-versions.out ] || { move tmp old; apt-show-versions > /root/.apt-show-versions.tmp && move tmp out; } || exit

. /etc/os-release || exit

set -o pipefail

grep -v ' not installed$' .apt-show-versions.out |
grep -v "/${VERSION_CODENAME}[ -]" || exit

