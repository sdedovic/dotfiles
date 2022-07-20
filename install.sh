#!/usr/bin/env bash

# Add/Remove packages here
archbox_pkgs="alacritty direnv music-mpd nix tmux vim zsh"
macos_pkgs="alacritty-mac direnv nix tmux vim zsh"

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
