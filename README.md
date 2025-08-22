Dotfiles managed using stow

# Get keys

```bash
sudo apt install curl git ansible -y
curl https://raw.githubusercontent.com/fjararibet/.dotfiles/main/.decrypt_keys.sh | bash
```


# Stow setup for nix
```
stow */ --ignore=configuration.nix
sudo stow nixos/ -t /etc/nixos/
```
