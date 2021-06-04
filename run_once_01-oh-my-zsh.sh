#!/bin/bash

echo "Clonning or updating oh-my-zsh"

git -C ~/.oh-my-zsh pull || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 

echo "Clonning or updating plugins"

git -C ~/.oh-my-zsh-custom/plugins/zsh-autosuggestions pull || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh-custom/plugins/zsh-autosuggestions

git -C ~/.oh-my-zsh-custom/plugins/zsh-syntax-highlighting pull || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh-custom/plugins/zsh-syntax-highlighting

git -C ~/.oh-my-zsh-custom/plugins/fzf-tab pull || git clone --depth 1 https://github.com/Aloxaf/fzf-tab ~/.oh-my-zsh-custom/plugins/fzf-tab

echo "Clonning or updating theme"

git -C ~/.oh-my-zsh-custom/themes/powerlevel10k pull || git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh-custom/themes/powerlevel10k

echo "Making ZSH the default shell"
chsh -s $(which zsh)
