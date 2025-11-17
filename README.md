# dotfiles
This codebase uses [Home Manager](https://github.com/nix-community/home-manager) and Nix flakes to setup and manager my personal environment. The user environment may be installed "standalone" or encorporated into a NixOS system with the provided flake outputs.

## What's Included (i.e. how do I computer)
**modules**
- [direnv](https://direnv.net)
- [tmux](https://github.com/tmux/tmux/wiki)
- [Zsh](https://www.zsh.org) + [Oh My Zsh](https://ohmyz.sh) + [z](https://github.com/rupa/z)
- [Alacritty](https://alacritty.org)
- [fzf](https://github.com/junegunn/fzf)
- [Git](https://git-scm.com)
- [Nix](https://nixos.org/nix)
- [neovim](https://neovim.io)
- programming languages
  - [Clojure](http://clojure.org)
  - [Julia](http://julialang.org/)
  - [Rust](https://www.rust-lang.org) (externally managed)
  - [NodeJs (JavaScript)](https://nodejs.org/en)
 
**packages**
- [argc](https://github.com/sigoden/argc)
- [ci-tool](./pkgs/ci-tool)

**software**
- [mdcat](https://github.com/swsnr/mdcat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [jq](https://jqlang.github.io/jq/)
- [htop](https://htop.dev/)
- [stow](https://www.gnu.org/software/stow/)
- [ranger](https://github.com/ranger/ranger)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)

## Using
### Standalone
```
home-manager switch --flake .#[stevan-wsl|stevan-mac|stevan]
```

#### Prerequisites
- `home-manager`
- `direnv` (optional)
- `nix` (optional)

Prefered installation is to use `direnv`, which will set up the default `devShell` and install `home-manager`.o

Alternatively, manually run `nix develop` to setup and install `home-manager`.

Alternatively, follow the `home-manager` installation guide.

### Common Issues
#### MacOS Upgrade Breaking
See [this github issue](https://github.com/NixOS/nix/issues/3616#issue-623807793):
Copying the following hook (copied from /etc/bashrc) to /etc/zshrc and restarting the shell fixed everything again:
```bash
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

