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
git clone --bare git@github.com:fjararibet/.dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
```
or 
```bash
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.github/README.md | bash
```
