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
# Get keys
```bash
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.decrypt_keys.sh | bash
```
# Install dotfiles
```bash
sudo apt install curl git ansible -y
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.install_dotfiles.sh | bash
```
# Setup with ansible
```bash
ansible-playbook $HOME/.setup.yml
```
# Install nvim config only
Save it to a file
```bash
curl https://github.com/fjararibet/.dotfiles/raw/main/install_nvim_conf.sh | bash
```

