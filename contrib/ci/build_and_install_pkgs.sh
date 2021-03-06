#!/bin/bash
set -e
set -x

VERSION=`git describe | sed 's/-/.r/;s/-/./'`
[ -z $VERSION ] && VERSION=`head meson.build | grep ' version :' | cut -d \' -f2`

# prepare the build tree
rm -rf build
mkdir build && pushd build
cp ../contrib/PKGBUILD .
sed -i "s,#VERSION#,$VERSION," PKGBUILD
mkdir -p src/fwupd && pushd src/fwupd
ln -s ../../../* .
popd
chown nobody . -R

# build the package and install it
sudo -u nobody makepkg -e --noconfirm
pacman -U --noconfirm *.pkg.tar.xz

# move the package to working dir
mv *.pkg.tar.xz ../

# no testing here because gnome-desktop-testing isn’t available in Arch
