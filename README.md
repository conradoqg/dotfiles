# Dotfiles

## Installing

```console
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply conradoqg
```

## Testing

```console
$ docker run -it --rm -v $PWD:/root/.local/share/chezmoi ubuntu-chezmoi bash
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply
```

## Links

- Dotfiles Manager:
	- [chezmoi](https://github.com/twpayne/chezmoi)
- ZSH Framework:
	- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)
- Oh-My-ZSH Theme:
	- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Oh-My-ZSH Plugins:
	- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
	- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
	- [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
	- [jump](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jump)

