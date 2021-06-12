#!/bin/bash

on_success="✓"
on_fail="X"
white="\e[1;37m"
green="\e[1;32m"
red="\e[1;31m"
yellow="\e[1;33m"
nc="\e[0m"

# usage:
#   1. source this script in your's
#   2. start the spinner:
#       start_spinner [display-message-here]
#   3. run your command
#   4. stop the spinner:
#       stop_spinner [your command's exit status]
function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)
    case $1 in
        start)
            # display message and position the cursor in $column column
            echo -ne "${2} ${yellow}  ${nc}"            

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}            

            while :
            do                
                printf "\b\b${yellow}${sp:i++%${#sp}:1} ${nc}"
                sleep $delay
            done            
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b\b"
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e ""
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner() {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner() {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

function run() {
    start_spinner "$1"		
    output=$($2 2>&1) 	
    exitCode=$?
    stop_spinner $exitCode
    if [ $exitCode -ne 0 ]; then 
        echo -e "$output"
        exit 1        
    fi 
}

function sudo() {
	[[ $EUID = 0 ]] || set -- command sudo "$@"
	"$@"
}

function environment() {
	unameOut="$(uname -s)"
	case "${unameOut}" in
		Linux*)     machine=Linux;;
		Darwin*)    machine=Mac;;
		CYGWIN*)    machine=Cygwin;;
		MINGW*)     machine=MinGw;;
		*)          machine="UNKNOWN:${unameOut}"
	esac
}

function distribution() {
	if [ -f /etc/os-release ]; then
		# freedesktop.org and systemd
		. /etc/os-release
		OS=$NAME
		VER=$VERSION_ID
	elif type lsb_release >/dev/null 2>&1; then
		# linuxbase.org
		OS=$(lsb_release -si)
		VER=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
		# For some versions of Debian/Ubuntu without lsb_release command
		. /etc/lsb-release
		OS=$DISTRIB_ID
		VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
		# Older Debian/Ubuntu/etc.
		OS=Debian
		VER=$(cat /etc/debian_version)
	elif [ -f /etc/SuSe-release ]; then
		# Older SuSE/etc.
		...
	elif [ -f /etc/redhat-release ]; then
		# Older Red Hat, CentOS, etc.
		...
	else
		# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
		OS=$(uname -s)
		VER=$(uname -r)
	fi
}

function github_download_and_install() {	
	tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
	url=$(curl -s https://api.github.com/repos/$1/releases/latest | grep -o "$2")
	basename=$(basename $url)
	curl -fsL $url -o $tmp_dir/$basename
	if [ "$5" == "tar.gz" ]; then
		tar -xzvf $tmp_dir/$basename -C $tmp_dir
	elif [ "$5" == "zip" ]; then
		unzip -o -d $tmp_dir $tmp_dir/$basename
	elif [ "$5" == "exe" ]; then
		mv $tmp_dir/$basename $tmp_dir/$3
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
	git -C $1 pull || git clone --depth 1 $2 $1 
}

function install_apt() {( set -e
	export DEBIAN_FRONTEND=noninteractive
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
		jq -y || return
)}

function install_binaries() {( set -e
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
)}

function install_pip() {( set -e
	pip install \
		bpytop \
		glances	
)}

function install_ohmyzsh() {( set -e
	pull_or_clone ~/.oh-my-zsh https://github.com/ohmyzsh/ohmyzsh.git
)}

function install_ohmyzsh_plugins() {( set -e
	pull_or_clone ~/.oh-my-zsh-custom/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git

	pull_or_clone ~/.oh-my-zsh-custom/plugins/fast-syntax-highlighting https://github.com/zdharma/fast-syntax-highlighting.git

	pull_or_clone ~/.oh-my-zsh-custom/plugins/fzf-tab https://github.com/Aloxaf/fzf-tab 

	pull_or_clone ~/.oh-my-zsh-custom/plugins/you-should-use https://github.com/MichaelAquilina/zsh-you-should-use
)}

function install_powerlevel10k() {( set -e
	pull_or_clone ~/.oh-my-zsh-custom/themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git
)}

function make_zsh_default() {( set -e
	if [[ $(grep $(whoami) </etc/passwd | cut -f 7 -d ":") != $(which zsh) ]]; then 
		chsh -s $(which zsh)	
	fi
)}

environment
echo -e "Environment found: ${yellow}$machine${nc}"
distribution
echo -e "Distribution found: ${yellow}$OS $VER${nc}"

if [ "$machine" != "MinGw" ]; then
	sudo true
	if [ $? -ne 0 ]; then		
		exit 1
	fi

	run "Upstalling APT packages" "install_apt"
	run "Upstalling standalone binaries" "install_binaries"
	run "Upstalling pip binaries" "install_pip"
	run "Upstalling oh-my-zsh" "install_ohmyzsh"
	run "Upstalling oh-my-zsh plugins" "install_ohmyzsh_plugins"
	run "Upstalling powerlevel10k" "install_powerlevel10k"
	run "Making ZSH the default shell" "make_zsh_default"
fi
