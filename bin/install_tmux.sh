#!/usr/bin/env bash

pod="tmux"
shenv_path=$HOME/.local/opt/shenv

# Deploy TPM - Tmux Plugin Manager
install_path=$HOME/.tmux/plugins
if [[ ! -d $install_path ]]; then
    mkdir -p $install_path
    git clone https://github.com/tmux-plugins/tpm $install_path
fi

# Deploy .tmux.conf
rm -f $HOME/.tmux.conf
ln -sf $shenv_path/tmux/.tmux.conf $HOME/.tmux.conf
echo "Updated symlink to Tmux configuration file: $HOME/.tmux.conf"

# Deploy Tmuxinator

