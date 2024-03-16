#!/bin/sh

# DOWNLOAD THE ARCHIVE
wget https://github.com/ivan-hc/junest/releases/download/continuous/junest-x86_64.tar.gz

# SET APPDIR AS A TEMPORARY $HOME DIRECTORY, THIS WILL DO ALL WORK INTO THE APPDIR
HOME="$(dirname "$(readlink -f $0)")" 

# DOWNLOAD AND INSTALL JUNEST (DON'T TOUCH THIS)
git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
./.local/share/junest/bin/junest setup -i junest-x86_64.tar.gz

# DOWNLOAD YAY-BIN (JuNest uses its own YAY version, we will replace it with an updated one)
wget $(wget -q https://api.github.com/repos/Jguer/yay/releases/latest -O - | grep -i x86_64 | grep browser_download_url | grep -i tar.gz | cut -d '"' -f 4 | head -1)
tar fx yay*tar.gz
mv ./yay_*/yay ./.junest/usr/bin/yay
rm -R -f yay_*

# BYPASS SIGNATURE CHECK LEVEL
#sed -i 's/#SigLevel/SigLevel/g' ./.junest/etc/pacman.conf
#sed -i 's/Required DatabaseOptional/Never/g' ./.junest/etc/pacman.conf

# UPDATE ARCH LINUX IN JUNEST
./.local/share/junest/bin/junest -- sudo pacman -Syy
./.local/share/junest/bin/junest -- sudo pacman --noconfirm -Syu
echo yes | ./.local/share/junest/bin/junest -- sudo pacman -Scc
