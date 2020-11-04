#!/usr/bin/env bash

pod="neovim"
filepath="$HOME/.local/share/nvim/site/autoload/plug.vim"
source $shenv_path/bin/bash_functions.sh

if [[ ! -f "$filepath" ]]; then
    echo "Downloading Vim-Plug from source..."
    curl -fLo $filepath --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# Deploy .vimrc
if [[ ! -d $HOME/.config/nvim ]]; then
    echo "Neovim: Creating symlink for init.vim."
    mkdir -p $HOME/.config/nvim
    ln -sf $shenv_path/neovim/init.vim $HOME/.config/nvim/init.vim
    ln -sf $shenv_path/neovim/init.vim $HOME/.vimrc
    echo "Updating NeoVim plugins using PlugInstall..."
    nvim +'PlugInstall --sync' +'UpdateRemotePlugins' +'PlugClean' +qa
fi

