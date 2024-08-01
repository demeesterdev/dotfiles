# .files demeesterdev

# dotfiles

[![GitHub Actions pre-commit status](https://github.com/demeesterdev/dotfiles/workflows/pre-commit/badge.svg)](https://github.com/demeesterdev/dotfiles/actions/workflows/pre-commit.yaml?query=branch%3Amain)

These are my dotfiles. This repository helps me to setup and maintain my installation. Feel free to explore, learn and copy for your own dotfiles.

## Setup dotfiles

On Linux

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

~/.local/bin/chezmoi init --apply demeesterdev
```

On Windows

```powershell
winget install twpayne.chezmoi

chezmoi init --apply demeesterdev
```

## Updating dotfiles

```bash
# pull only
chezmoi update --apply=false

chezmoi apply
```
