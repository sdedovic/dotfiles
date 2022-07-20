# dotfiles

```bash
# Easy mode
# os can be 'arch' or 'mac'
./install.sh [os]
```

## Installing
**Dependencies**
```bash
git submodule init && git submodule update
```

**Individual Packages**
```bash
stow -t ~ <name of package>

# example, zsh configs
stow -t ~ zsh
```
