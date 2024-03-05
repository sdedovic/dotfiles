# dotfiles
This codebase uses [Home Manager](https://github.com/nix-community/home-manager) and Nix flakes to setup and manager my personal environment. The user environment may be installed "standalone" or encorporated into a NixOS system with the provided flake outputs.

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
