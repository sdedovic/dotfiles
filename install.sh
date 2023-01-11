#!/usr/bin/env bash

# Add/Remove packages here
archbox_pkgs="alacritty direnv music-mpd nix tmux vim nvim zsh picom"
macos_pkgs="alacritty-mac direnv nix tmux vim nvim zsh"

cmd="stow"
install() {
	if [[ $1 = "linux" || $1 = "arch" || $1 = "archbox" ]]
	then
		packages="$archbox_pkgs"
	elif [[ $1 = "mac" || $1 = "macos" ]]
	then
		packages="$macos_pkgs"
	else
		echo "Unknown system: [$1]"
		exit 1
	fi

	echo "Installing packages for [$1]"
	for pkg in $packages; do
		echo "  Installing [$pkg]"
		$($cmd -t ~ $pkg)
	done
}

init() {
  if [[ ! -d ~/.oh-my-zsh ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  fi
  (cd ~/.oh-my-zsh && git pull)

  if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-fish --no-zsh --no-update-rc
  fi
  (cd ~/.fzf && git pull && ./install --all --no-fish --no-zsh --no-update-rc)

  if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi

	echo "Updating git submodules"
	git submodule init
	git submodule update
}

if [[ $# -eq 0 ]]
then
	echo "No system specified."
	echo "Try running 'install.sh linux' or 'install.sh mac'"
	exit 1
fi
init
install $1
echo "Done"
