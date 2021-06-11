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
	echo "Installing $1"
	
	tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
	url=$(curl -s https://api.github.com/repos/$1/releases/latest | grep -o "$2")
	basename=$(basename $url)
	curl -fsL $url -o $tmp_dir/$basename > /dev/null
	if [ "$5" == "tar.gz" ]; then
		tar -xzvf $tmp_dir/$basename -C $tmp_dir > /dev/null
	elif [ "$5" == "zip" ]; then
		unzip -o -d $tmp_dir $tmp_dir/$basename > /dev/null
	elif [ "$5" == "exe" ]; then
		mv $tmp_dir/$basename $tmp_dir/$3 > /dev/null
	else
		echo "Unknown file type"
		exit 1
	fi
	chmod +x $tmp_dir/$3
	mv $tmp_dir/$3 ~/.local/bin
	rm -rf $tmp_dir	
}

# $1 Destination
# $2 Git URL
function pull_or_clone() {
	git -C $1 pull 2> /dev/null || git clone --depth 1 $2 $1
}

environment

echo "Environment found: $machine"

if [ "$machine" != "MinGw" ]; then
	echo "Installing APT packages"
	
	sudo apt-get update
	sudo apt-get install \
		wget \
		git \
		zsh \
		vim \
		fd-find \
		tree \
		bat \
		most \
		ncdu \
		htop \
		git-extras git-flow \
		direnv \
		zip unzip \
		mtr \
		python3-pip \
		jq -y		

	echo "Installing standalone binaries"
	github_download_and_install "extrawurst/gitui" "https://.*gitui-linux-musl.tar.gz" "gitui" "gitui" "tar.gz"
	github_download_and_install "jesseduffield/lazygit" "https://.*_Linux_x86_64.tar.gz" "lazygit" "lazygit" "tar.gz"
	github_download_and_install "ogham/exa" "https://.*-linux-x86_64-v.*.zip" "bin/exa" "exa" "zip"	
	github_download_and_install "muesli/duf" "https://.*duf_.*_linux_x86_64.tar.gz" "duf" "duf" "tar.gz"
	github_download_and_install "ogham/dog" "https://.*dog-.*-x86_64-unknown-linux-gnu.zip" "bin/dog" "dog" "zip"
	github_download_and_install "mikefarah/yq" "https://.*yq_linux_amd64.tar.gz" "yq_linux_amd64" "yq" "tar.gz"
	github_download_and_install "bcicen/ctop" "https://.*ctop-.*-linux-amd64" "ctop" "ctop" "exe"

	pull_or_clone ~/.fzf https://github.com/junegunn/fzf.git	
	~/.fzf/install --bin
	
	
	curl -sS https://webinstall.dev/k9s | bash

	curl https://getmic.ro | bash
	mv ./micro ~/.local/bin

	wget https://dystroy.org/broot/download/x86_64-linux/broot -O ~/.local/bin/broot
	chmod +x ~/.local/bin/broot
	
	echo "Install pip binaries"	
	pip install \
		bpytop \
		glances	
fi
