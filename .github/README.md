Bare repo to manage my dotfiles.
# Set up bare repository

```bash
git init --bare $HOME/.dotfiles 
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
``` 

Now `dotfiles` alias can be used the same way `git` is used.
```bash
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
dotfiles push
```

# Install dotfiles
```bash
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.install_dotfiles.sh | bash
```

# Gnome Configuration
Save it to a file
```bash
dconf dump / > .dconf_dump
```
Loading it
```bash
dconf load / < .dconf_dump
```

