# Dotfiles

## Installing

```console
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply conradoqg
```

## Testing

```console
$ docker run -it --rm -v $PWD:/root/.local/share/chezmoi ubuntu bash
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
	- [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
	- [transfer](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/transfer)
	- [command-not-found](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found)
	- [docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)
	- [kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl)
	- [git-extras](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-extras)
	- [git-flow](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-flow)
	- [direnv](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/direnv)
	- [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)
	- [fzf](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf)
	- [fzf-tab](https://github.com/Aloxaf/fzf-tab)
	- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
	- [fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)	
	- [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)	
	- [you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)
	- [alias-finder](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder)

## Installed packages

- most
- [tree](https://github.com/kddeisz/tree)
- [ncdu](https://dev.yorhel.nl/ncdu)
- [htop](https://htop.dev/)
- [jq](https://stedolan.github.io/jq/)
- [yq](https://github.com/mikefarah/yq)
- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [git-extras](https://github.com/tj/git-extras)
- [gitflow](https://github.com/nvie/gitflow/wiki/Linux)
- [direnv](https://direnv.net/)
- [fd-find](https://github.com/sharkdp/fd)
- [glances](https://nicolargo.github.io/glances/)
- [gitui](https://github.com/extrawurst/gitui)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [exa](https://github.com/ogham/exa)
- [bpytop](https://github.com/aristocratos/bpytop)
- [alias-finder](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder)
- [k9s](https://github.com/derailed/k9s)
- [micro](https://github.com/zyedidia/micro)
- [duf](https://github.com/muesli/duf)
- [dog](https://github.com/ogham/dog)
- [broot](https://github.com/Canop/broot)
- [ctop](https://github.com/bcicen/ctop)
- [mtr](http://www.bitwizard.nl/mtr/)

## Shortcuts

- <kbd>Ctrl</kbd> + <kbd>H</kbd>: FZF History
- <kbd>Ctrl</kbd> + <kbd>G</kbd>: FZF Bookmark
- `**` + <kbd>TAB</kbd>: FZF Finder

## Aliases
- `readme`: See this file
- `ls`: `exa`
- `bat`: `batcat`
- `m`: `micro`
- `lg`: `lazygit`
- `cm`: `chezmoi`
- `mark`: bookmark directry

## Scripts
- `preview`: See the contents of a file or a dir

## Useful links
- [The 50 Most Useful Linux Commands To Run in the Terminal](https://www.ubuntupit.com/best-linux-commands-to-run-in-the-terminal/)
- [Unix System Monitoring and Diagnostic CLI Tools](https://monadical.com/posts/system-monitoring-tools.html)
- [Linux CLI Tools](https://wiki.tilde.fun/admin/linux/cli/start)
- [Linux Performance](http://www.brendangregg.com/linuxperf.html)

