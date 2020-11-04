#!/usr/bin/env bash

pod="powerline"
install_path=$HOME/.config/powerline/themes/shell

if [[ -d $install_path ]]; then
    echo "$pod has been installed."
    exit
fi

/usr/bin/python3 -m pip install --user --upgrade powerline-status
/usr/bin/python -m pip install --user --upgrade powerline-status

mkdir -p $install_path
ln -sf $shenv_path/powerline/themes/shell/default.json $install_path/default.json
