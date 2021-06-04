#!/bin/bash

set -e

sudo() {
	[[ $EUID = 0 ]] || set -- command sudo "$@"
	"$@"
}

environment() {
	unameOut="$(uname -s)"
	case "${unameOut}" in
		Linux*)     machine=Linux;;
		Darwin*)    machine=Mac;;
		CYGWIN*)    machine=Cygwin;;
		MINGW*)     machine=MinGw;;
		*)          machine="UNKNOWN:${unameOut}"
	esac
}

github_download_and_install() {
	if [ ! -f ~/.local/bin/$4 ]; then
		tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
		curl -fsL https://www.github.com/$1/releases/latest/download/$2 -o $tmp_dir/$2
		if [ "$5" == "tgz" ]; then		
			tar -xzvf $tmp_dir/$2 -C $tmp_dir
		elif [ "$5" == "zip" ]; then
			unzip -o -d $tmp_dir $tmp_dir/$2
		else
			echo "Unknown file type"
			exit 1
		fi
		chmod +x $tmp_dir/$3
		mv $tmp_dir/$3 ~/.local/bin
		rm -rf $tmp_dir
	fi
}

environment

echo "Environment found: $machine"

if [ "$machine" != "MinGw" ]; then
	echo "Installing APT packages"
	sudo apt-get update 
	sudo apt-get install \
		git \
		zsh \
		vim \
		fzf \
		fd-find \
		tree \
		bat \
		ncdu \
		htop \
		git-extras git-flow \
		direnv \
		xclip xsel \
		zip unzip \
		bpytop \
		glances -y

	echo "Installing standalone binaries"
	github_download_and_install "extrawurst/gitui" "gitui-linux-musl.tar.gz" "gitui" "gitui" "tgz"
	github_download_and_install "jesseduffield/lazygit" "lazygit_0.28.1_Linux_x86_64.tar.gz" "lazygit" "lazygit" "tgz"
	github_download_and_install "ogham/exa" "exa-linux-x86_64-v0.10.1.zip" "bin/exa" "exa" "zip"

	echo "Installing scripts"
	sudo mv scripts/* ~/.local/bin
fi
