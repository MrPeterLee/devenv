#!/usr/bin/env bash

pod="karabiner"
install_path=$HOME/.config/karabiner

if [[ -d $install_path ]]; then
    echo "$pod has been installed."
    exit
fi

if [[ ! "${OS_NAME}" == "Mac" ]]; then
    echo "Installer of $pod does not support $OS_NAME."
    exit
fi

# Mac Only
if [[ ! -d $install_path ]]; then
    rm -rf $install_path
    ln -sf $shenv_path/karabiner $install_path
fi
