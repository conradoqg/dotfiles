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
		url=$(curl -s https://api.github.com/repos/$1/releases/latest | grep -o "$2")
		basename=$(basename $url)

		curl -fsL $url -o $tmp_dir/$basename

		if [ "$5" == "tar.gz" ]; then
			tar -xzvf $tmp_dir/$basename -C $tmp_dir
		elif [ "$5" == "zip" ]; then
			unzip -o -d $tmp_dir $tmp_dir/$basename
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
		zip unzip \
		glances \
		micro \
		pip -y

	echo "Installing standalone binaries"
	github_download_and_install "extrawurst/gitui" "https://.*gitui-linux-musl.tar.gz" "gitui" "gitui" "tar.gz"
	github_download_and_install "jesseduffield/lazygit" "https://.*_Linux_x86_64.tar.gz" "lazygit" "lazygit" "tar.gz"
	github_download_and_install "ogham/exa" "https://.*-linux-x86_64-v.*.zip" "bin/exa" "exa" "zip"

	curl -sS https://webinstall.dev/k9s | bash

	echo "Install pip binaries"
	pip install bpytop
fi
