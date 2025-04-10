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
sudo apt install curl git ansible -y
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.decrypt_keys.sh | bash
```

# Setup with ansible
```bash
curl --remote-name https://raw.githubusercontent.com/fjararibet/.dotfiles/refs/heads/main/.setup.yml
ansible-playbook $HOME/.setup.yml -K
```
For some reason make needs to be run twice for popshell, the second time after a logout, the command can be run manually
```
cd .shell
make local-install
```
or 
```ansible-playbook $HOME/.setup.yml -K --tags popshell```
after logout

# Install dotfiles
```bash
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.install_dotfiles.sh | bash
```
you also may want to run
```bash
nvm install node
```
for nvim plugins
# Install nvim config only
Save it to a file
```bash
curl https://github.com/fjararibet/.dotfiles/raw/main/install_nvim_conf.sh | bash
```

