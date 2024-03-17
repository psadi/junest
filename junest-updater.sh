#!/usr/bin/env bash

# DOWNLOAD THE ARCHIVE
wget https://github.com/ivan-hc/junest/releases/download/20240108/junest-x86_64.tar.gz

# SET APPDIR AS A TEMPORARY $HOME DIRECTORY, THIS WILL DO ALL WORK INTO THE APPDIR
HOME="$(dirname "$(readlink -f $0)")" 

# DOWNLOAD AND INSTALL JUNEST (DON'T TOUCH THIS)
git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
./.local/share/junest/bin/junest setup -i junest-x86_64.tar.gz

# BYPASS SIGNATURE CHECK LEVEL
#sed -i 's/#SigLevel/SigLevel/g' ./.junest/etc/pacman.conf
#sed -i 's/Required DatabaseOptional/Never/g' ./.junest/etc/pacman.conf

# UPDATE ARCH LINUX IN JUNEST
./.local/share/junest/bin/junest -- sudo pacman -Syy
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Syu

# INSTALL YAY
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns yay
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -S --needed git base-devel
./.local/share/junest/bin/junest -- git clone https://aur.archlinux.org/yay.git
cd yay
echo yes | $HOME/.local/share/junest/bin/junest -- makepkg -si
cd ..

if ! test -f ./.junest/usr/bin/yay; then
	rsync -av ./yay/pkg/yay/usr/* ./.junest/usr/
	rsync -av ./yay/pkg/yay-debug/usr/* ./.junest/usr/
fi

# DEBLOAT
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Rcns base-devel go
echo yes | ./.local/share/junest/bin/junest -- sudo pacman -Scc

echo -e 'SUCCESS!\n'
