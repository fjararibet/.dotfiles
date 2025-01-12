#!/usr/bin/env bash

# Note that is a BARE repo
git clone --bare git@github.com:fjararibet/.dotfiles.git $HOME/.dotfiles

# we haven't created the dotfiles alias yet,
# so we create it as a function for now 
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles checkout
if [ $? = 0 ]; then
  echo "dotfiles successfully installed.";
else
    #echo "Moving existing dotfiles to ~/.dotfiles-backup";
    #mkdir .dotfiles-backup
    #dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles-backup/{}
fi

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

