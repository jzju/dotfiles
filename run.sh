#!/bin/bash

sudo apt install -y \
build-essential \
curl \
htop \
nvtop \
vim \
wget \
zsh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir -p ~/.ipython/profile_default/startup/
ln -s $DIR/.zshrc ~/.zshrc
ln -s $DIR/.zsh_alias ~/.zsh_alias
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/50-import.py ~/.ipython/profile_default/startup/50-import.py
ln -s $DIR/ipython_config.py ~/.ipython/profile_default/ipython_config.py
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
sudo chsh -s /bin/zsh $USER

curl -LsSf https://astral.sh/uv/install.sh | sh
curl -LsSf https://astral.sh/ruff/install.sh | sh
