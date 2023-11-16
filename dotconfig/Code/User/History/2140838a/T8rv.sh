#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/backgrounds/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# Installing Essential Programs 
nala install feh kitty rofi picom thunar nitrogen lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev -y
# Installing Other less important Programs
nala install neofetch flameshot psmisc mangohud vim lxappearance papirus-icon-theme fonts-noto-color-emoji -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir 
nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip




### copy another files ###
# autostart for dwm
sudo mkdir -p $HOME/.local/share/dwm
sudo cp $HOME/Antar-dwm/dotconfig/autostart.sh $HOME/.local/share/dwm/

# config doas
sudo cp $HOME/Antar-dwm/dotconfig/doas.conf /etc/

### for tmux ###
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


### Add Fonts ###
sudo mkdir -p $HOME/.local/share/fonts
sudo mkdir -p /usr/share/fonts
sudo cp -r $HOME/Antar-dwm/Source/fonts/* $HOME/.local/share/fonts/
sudo cp -r $HOME/Antar-dwm/Source/fonts/* /usr/share/fonts/

# Reloading Font
fc-cache -vf


### Add themes ###
sudo mkdir -p $HOME/.themes
sudo mkdir -p /usr/share/themes
sudo cp -r $HOME/Antar-dwm/Source/themes/* $HOME/.themes/
sudo cp -r $HOME/Antar-dwm/Source/themes/* /usr/share/themes/


### Add icons ###
sudo mkdir -p $HOME/.icons
sudo mkdir -p /usr/share/icons
sudo cp -r $HOME/Antar-dwm/Source/icons/* $HOME/.icons/
sudo cp -r $HOME/Antar-dwm/Source/icons/* /usr/share/icons/


### for vscode ###
sudo mkdir -p $HOME/.vscode
sudo cp -r $HOME/Antar-dwm/Source/code/* $HOME/.vscode


### Clone suckless's ###
cd $HOME/
git clone https://github.com/yousseffjel/suckless.git
cd ~/suckless/dwm;sudo rm -f config.h;make;sudo make install clean
cd ~/suckless/slstatus;sudo rm -f config.h;make;sudo make install clean


### clone bin repo
cd $HOME/
git clone https://github.com/yousseffjel/bin.git

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Install brave-browser
nala install apt-transport-https curl -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y


# Ly Console Manager
# Needed packages
sudo apt install -y libpam0g-dev libxcb-xkb-dev
cd 
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
sudo make install installsystemd
sudo systemctl enable ly.service


# XSessions and dwm.desktop
if [[ ! -d /usr/share/xsessions ]]; then
    sudo mkdir /usr/share/xsessions
fi

cat > ./temp << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF
sudo cp ./temp /usr/share/xsessions/dwm.desktop;rm ./temp


# Beautiful bash
git clone https://github.com/yousseffjel/bash
cd bash
bash setup.sh
cd $builddir

# Use nala
bash scripts/usenala
