#!/bin/bash

# $1 Destination
# $2 Git URL
function pull_or_clone() {
	git -C ~/.oh-my-zsh pull 2> /dev/null || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 
}

echo "Clonning or updating oh-my-zsh"

pull_or_clone ~/.oh-my-zsh pull https://github.com/ohmyzsh/ohmyzsh.git

echo "Clonning or updating plugins"

pull_or_clone ~/.oh-my-zsh-custom/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git

pull_or_clone ~/.oh-my-zsh-custom/plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

pull_or_clone ~/.oh-my-zsh-custom/plugins/fzf-tab https://github.com/Aloxaf/fzf-tab 

pull_or_clone ~/.oh-my-zsh-custom/plugins/you-should-use https://github.com/MichaelAquilina/zsh-you-should-use

echo "Clonning or updating theme"

pull_or_clone ~/.oh-my-zsh-custom/themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git

echo "Making ZSH the default shell"

if [[ $(grep $USER </etc/passwd | cut -f 7 -d ":") != $(which zsh) ]]; then 
	chsh -s $(which zsh)
else
	echo "Already default"
fi
