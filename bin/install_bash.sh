#!/bin/bash

pod="bash"
filepath="$HOME/.bashrc"

if [[ "${OS_NAME}" == "Linux" ]]; then
    rm -f $HOME/.bashrc
    ln -sf $shenv_path/bash/.bashrc $HOME/.bashrc
    source $HOME/.bashrc
fi
