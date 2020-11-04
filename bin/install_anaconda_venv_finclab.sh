#!/usr/bin/env bash

pod="anaconda_venv_finclab"
install_path=$HOME/.conda/envs/finclab

if [[ -d $install_path ]]; then
    echo "$pod has been installed."
    exit
fi

echo "Creating conda virtual environment finclab."
conda create -y --name finclab python pip quandl numpy pandas jupyter pytables autopep8 xlrd scipy openpyxl matplotlib seaborn nbconvert flake8 beautifulsoup4 mock toolz
conda install -y --name finclab -c conda-forge jupyter_contrib_nbextensions retrying jupyterlab ipywidgets requests neovim jedi pylint yapf nodejs pyperclip
conda activate finclab

pip install --upgrade pip
# zipline ecosystem
pip install trading-calendars lru-dict --user
# conda install -y --name finclab -c alpacahq pylivetrader pyfolio alphalens
# pip install black --user

# Jupyter lab plugins - Vim Bindings
rm -rf $(jupyter --data-dir)/nbextensions
mkdir -p $(jupyter --data-dir)/nbextensions
git clone https://github.com/lambdalisue/jupyter-vim-binding $(jupyter --data-dir)/nbextensions/vim_binding
chmod -R go-w $(jupyter --data-dir)/nbextensions/vim_binding
jupyter nbextension enable vim_binding/vim_binding

# Neovim plugins
pip2 install pynvim --user
pip install pynvim --user
