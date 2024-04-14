#!/usr/bin/env bash

git clone https://github.com/fjararibet/.dotfiles.git

cd .dotfiles
cp .config/nvim $HOME/.config/

cd ..
rm -rf .dotfiles
