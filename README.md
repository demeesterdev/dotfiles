# .files demeesterdev

These are my dotfiles. This repository helps me to setup and maintain my installation. Feel free to explore, learn and copy for your own dotfiles.

## Install

to install these dotfiles packages `make`, `git` and `ca-certificates` are needed.

```bash
wget -qO - https://raw.githubusercontent.com/demeesterdev/dotfiles/main/install.sh | bash -s dotfiles
```

for a fresh install of debian without these packages you can run a fresh install.

```bash
sudo apt install ca-certificates -y
wget -qO - https://raw.githubusercontent.com/demeesterdev/dotfiles/main/install.sh | sudo bash -s fresh
```

> !! you can run wget without preinstalling ca-certificates but there is a risk of downloading from a malicious source.  
> `wget --no-check-certificate -qO - https://raw.githubusercontent.com/demeesterdev/dotfiles/main/install.sh |`  
> `sudo bash -s fresh`