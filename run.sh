#!/bin/bash

sudo apt install -y \
build-essential \
curl \
python3-pip \
python3-dev \
vim \
wget \
zsh

sudo rm /usr/lib/python3.*/EXTERNALLY-MANAGED

sudo pip3 install -U \
black \
ipython \
notebook \
numpy \
openpyxl \
pandas

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p ~/.ipython/profile_default/startup/
ln -s $DIR/.zshrc ~/.zshrc
ln -s $DIR/.zsh_alias ~/.zsh_alias
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/50-import.py ~/.ipython/profile_default/startup/50-import.py
ln -s $DIR/ipython_config.py ~/.ipython/profile_default/ipython_config.py
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
sudo chsh -s /bin/zsh $USER
