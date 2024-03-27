#!/usr/bin/env bash

curl --remote-name https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.encrypted_keys/id_ed25519
curl --remote-name https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.encrypted_keys/id_ed25519.pub
cp id_ed25519* $HOME/.ssh
ansible-vault decrypt $HOME/.ssh/id_ed25519*


