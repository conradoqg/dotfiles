# Dotfiles

Gerenciado com [chezmoi](https://github.com/twpayne/chezmoi). Funciona em **Linux, WSL2 e macOS**, nas arquiteturas **x86_64 (amd64)** e **arm64** (inclui Apple Silicon).

## Installing

```console
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply conradoqg
```

Isso instala o chezmoi, clona este repositório e aplica tudo: pacotes do sistema, binários, oh-my-zsh + plugins + tema, e os dotfiles.

## Como funciona (arquitetura)

| Camada | Mecanismo | Arquivo |
|---|---|---|
| Config por máquina (os/arch/pkgManager/isWSL) | template de config | `.chezmoi.toml.tmpl` |
| Pacotes do gerenciador nativo (apt/brew) | script idempotente | `.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl` |
| Binários (Linux), plugins oh-my-zsh e tema p10k | externals declarativos | `.chezmoiexternal.toml.tmpl` |
| Dotfiles (`.zshrc`, `.p10k.zsh`, configs) | arquivos versionados | `dot_*`, `private_dot_config/*` |

No **Linux** os binários vêm de releases do GitHub (por OS/arch, com cache de 168h). No **macOS** tudo é instalado via **Homebrew**.

> Para evitar o rate limit da API do GitHub em CI, exporte `CHEZMOI_GITHUB_ACCESS_TOKEN`.

## Testing

O harness em `test/` faz um *fresh install* completo em containers limpos:

```console
$ ./test/run-matrix.sh                 # linux/amd64 + linux/arm64
$ ./test/run-matrix.sh linux/amd64     # só amd64
```

macOS não roda em Docker, então é testado no CI num runner `macos-14` (arm64) pelo caminho brew. Veja `.github/workflows/test.yml`.

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
	- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
	- [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)
	- [you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)
	- [alias-finder](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder)

## Installed packages

### Via gerenciador nativo (apt no Linux / brew no macOS)

- most
- [tree](https://gitlab.com/OldManProgrammer/unix-tree)
- [ncdu](https://dev.yorhel.nl/ncdu)
- [htop](https://htop.dev/)
- [jq](https://jqlang.github.io/jq/)
- [bat](https://github.com/sharkdp/bat) (no Ubuntu o binário é `batcat`; há alias `bat`)
- [fd-find](https://github.com/sharkdp/fd) (no Ubuntu o binário é `fdfind`; há alias `fd`)
- [git-extras](https://github.com/tj/git-extras)
- [gitflow](https://github.com/nvie/gitflow/wiki/Linux)
- [direnv](https://direnv.net/)
- [btop](https://github.com/aristocratos/btop) — monitor de recursos (substitui bpytop/glances)
- [mtr](https://www.bitwizard.nl/mtr/) (`mtr-tiny` no Linux)

### Via releases do GitHub (Linux) / brew (macOS)

- [eza](https://github.com/eza-community/eza) — `ls` moderno (substitui exa)
- [doggo](https://github.com/mr-karan/doggo) — cliente DNS (substitui dog)
- [gitui](https://github.com/gitui-org/gitui)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [lazydocker](https://github.com/jesseduffield/lazydocker) — TUI para Docker
- [duf](https://github.com/muesli/duf)
- [yq](https://github.com/mikefarah/yq)
- [ctop](https://github.com/bcicen/ctop)
- [k9s](https://github.com/derailed/k9s)
- [micro](https://github.com/micro-editor/micro)
- [broot](https://github.com/Canop/broot)
- [fzf](https://github.com/junegunn/fzf)
- [walk](https://github.com/antonmedv/walk) — navegador de arquivos TUI
- [dysk](https://github.com/Canop/dysk) — uso de disco
- [jnv](https://github.com/ynqa/jnv) — explorador interativo de JSON/`jq`
- [cloudflare-speed-cli](https://github.com/kavehtehrani/cloudflare-speed-cli) — teste de velocidade

## Shortcuts

- <kbd>Ctrl</kbd> + <kbd>H</kbd>: FZF History
- <kbd>Ctrl</kbd> + <kbd>G</kbd>: FZF Bookmark
- `**` + <kbd>TAB</kbd>: FZF Finder

## Aliases
- `readme`: See this file
- `ls`: `eza`
- `bat`: `batcat` (só no Ubuntu)
- `fd`: `fdfind` (só no Ubuntu)
- `m`: `micro`
- `lg`: `lazygit`
- `cm`: `chezmoi`
- `walk`: navegador de arquivos com ícones
- `mark`: bookmark directory

## Scripts
- `preview`: See the contents of a file or a dir

## Useful links
- [The 50 Most Useful Linux Commands To Run in the Terminal](https://www.ubuntupit.com/best-linux-commands-to-run-in-the-terminal/)
- [Unix System Monitoring and Diagnostic CLI Tools](https://monadical.com/posts/system-monitoring-tools.html)
- [Linux Performance](https://www.brendangregg.com/linuxperf.html)
