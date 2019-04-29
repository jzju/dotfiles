#!/usr/bin/env bash

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

if [[ "$1" == "db" ]]; then
    sudo bash -c '
    apt install -y dropbear-initramfs
    cd /etc/dropbear/initramfs
    cp /home/jj/.ssh/authorized_keys .
    dropbearconvert openssh dropbear /etc/ssh/ssh_host_ed25519_key dropbear_ed25519_host_key
    rm dropbear_ecdsa_host_key dropbear_rsa_host_key
    echo 'DROPBEAR_OPTIONS="-I 180 -j -k -s -c cryptroot-unlock"' > dropbear.conf
    update-initramfs -u
    '
fi
