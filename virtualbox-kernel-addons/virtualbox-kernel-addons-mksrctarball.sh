#!/bin/sh
# This script helps you to make the source package
# of the virtualbox guest additions kernel modules.
# IMPORTANT: The virtualbox-ose-addons version you want to use
# must already be installed!

# Based on the ffmpeg-mksrctarball.sh from the SlackBuilds.org repository

set -e

PRGNAM=virtualbox-kernel-addons
VERSION=$(VBoxControl -V | grep -e '^[0-9].[0-9].[0-9]*r[0-9]*' | cut -d "r" -f 1)

mkdir $PRGNAM

if [ -d /opt/VBoxGuestAdditions-$VERSION/src/vboxguest-$VERSION ]; then
  echo "--> Copying sourcecode from /opt/VBoxGuestAdditions-$VERSION/src"
  cp -rf /opt/VBoxGuestAdditions-$VERSION/src/vboxguest-$VERSION/vboxguest $PRGNAM/vboxguest
  cp -rf /opt/VBoxGuestAdditions-$VERSION/src/vboxguest-$VERSION/vboxsf $PRGNAM/vboxsf
  cp -rf /opt/VBoxGuestAdditions-$VERSION/src/vboxguest-$VERSION/vboxvideo $PRGNAM/vboxvideo
  # Patch the source first
  echo "--> Source is from upstream VBoxGuestAdditions."
  echo "----> Applying patches to fix building with Slackware current."
  cd $PRGNAM
  # GCC7 patch
  cat $CWD/udivmoddi4.c > vboxguest/common/math/gcc/udivmoddi4.c
  cat $CWD/uint64.h > vboxguest/include/iprt/uint64.h
  cat $CWD/udivmoddi4.c > vboxsf/udivmoddi4.c
  cat $CWD/uint64.h > vboxsf/include/iprt/uint64.h
  patch -p1 -i $CWD/virtualbox-kernel-addons-gcc7.patch
  # Linux 4.12 patch
  patch -p1 -i $CWD/virtualbox-kernel-addons-linux-4.12.patch
  echo "--> DONE"
  cd ..
else
  echo "--> Copying sourcecode from /usr/src"
  cp -rf /usr/src/vboxguest-$VERSION $PRGNAM/vboxguest
  cp -rf /usr/src/vboxsf-$VERSION $PRGNAM/vboxsf
  cp -rf /usr/src/vboxvideo-$VERSION $PRGNAM/vboxvideo
fi

echo "--> Making the sourcecode tarball: $PRGNAM-src-$VERSION.tar.xz"
tar -cJf $PRGNAM-$VERSION.tar.xz $PRGNAM

echo "--> Erasing the sourcecode directory: $PRGNAM/"
rm -rf $PRGNAM/

echo "--> Sourcecode tarball for $PRGNAM: $PRGNAM-$VERSION.tar.xz"
