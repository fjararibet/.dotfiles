#!/usr/bin/env bash

# Note that this is a BARE repo
git clone --bare git@github.com:fjararibet/.dotfiles.git $HOME/.dotfiles

# Create the dotfiles function
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

# Try to check out the dotfiles
dotfiles checkout
if [ $? -ne 0 ]; then
  echo "Conflicts detected. Resolving by removing conflicting files..."
  
  # List and remove conflicting files
  dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}' | while read -r file; do
    rm -rf "$HOME/$file"
  done
  
  # Retry the checkout
  dotfiles checkout
  if [ $? -eq 0 ]; then
    echo "dotfiles successfully installed.";
  else
    echo "Failed to install dotfiles. Please check for remaining issues.";
    exit 1
  fi
else
  echo "dotfiles successfully installed.";
fi

# Configure dotfiles to not show untracked files
dotfiles config --local status.showUntrackedFiles no
