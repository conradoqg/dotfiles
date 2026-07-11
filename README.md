# Dotfiles

Managed with [chezmoi](https://github.com/twpayne/chezmoi). Works on **Linux, WSL2 and macOS**, on **x86_64 (amd64)** and **arm64** (including Apple Silicon).

## Installing

```console
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply conradoqg
```

This installs chezmoi, clones this repository and applies everything: system packages, binaries, oh-my-zsh + plugins + theme, and the dotfiles.

## How it works (architecture)

| Layer | Mechanism | File |
|---|---|---|
| Per-machine config (os/arch/pkgManager/isWSL) | config template | `.chezmoi.toml.tmpl` |
| Native package manager packages (apt/brew) | idempotent script | `.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl` |
| Docker, cloud CLIs and AI CLIs | idempotent installer scripts | `.chezmoiscripts/run_onchange_*` |
| Binaries (Linux), oh-my-zsh plugins and the p10k theme | declarative externals | `.chezmoiexternal.toml.tmpl` |
| Dotfiles (`.zshrc`, `.p10k.zsh`, `.gitconfig`, configs) | versioned files | `dot_*`, `private_dot_config/*` |

On **Linux** the binaries come from GitHub releases (per OS/arch, cached for 168h). On **macOS** everything is installed via **Homebrew**.

> To avoid the GitHub API rate limit in CI, export `CHEZMOI_GITHUB_ACCESS_TOKEN`.

## Testing

The harness under `test/` does a full *fresh install* in clean containers:

```console
$ ./test/run-matrix.sh                 # linux/amd64 + linux/arm64
$ ./test/run-matrix.sh linux/amd64     # amd64 only
```

macOS cannot run in Docker, so it is tested in CI on a `macos-14` runner (arm64) through the brew path. See `.github/workflows/test.yml`.

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

Origin: 📦 native package manager (apt on Linux / brew on macOS) · ⬢ GitHub release (Linux; brew on macOS) · 🔧 official installer script (idempotent).

### Shell & files

- ⬢ [eza](https://github.com/eza-community/eza) — modern `ls` with icons, colors and a git column; replaces exa
- 📦 [bat](https://github.com/sharkdp/bat) — `cat` with syntax highlighting, line numbers and git integration (on Ubuntu the binary is `batcat`; aliased to `bat`)
- 📦 [fd-find](https://github.com/sharkdp/fd) — fast, friendly alternative to `find` (on Ubuntu the binary is `fdfind`; aliased to `fd`)
- ⬢ [ripgrep](https://github.com/BurntSushi/ripgrep) — extremely fast recursive text search (`rg`); respects `.gitignore`
- 📦 [tree](https://gitlab.com/OldManProgrammer/unix-tree) — lists directory contents as a tree
- ⬢ [broot](https://github.com/Canop/broot) — directory tree navigator with fuzzy search
- ⬢ [walk](https://github.com/antonmedv/walk) — fast TUI file browser with icons
- ⬢ [fzf](https://github.com/junegunn/fzf) — command-line fuzzy finder (history, files, etc.)
- ⬢ [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd` that learns your most-used directories (provides `z`)
- 📦 [most](https://www.jedsoft.org/most/) — pager (like `less`) with colors and multiple windows

### Git

- ⬢ [gitui](https://github.com/gitui-org/gitui) — fast, lightweight Git TUI (stage/commit/diff/log) in Rust
- ⬢ [lazygit](https://github.com/jesseduffield/lazygit) — full-featured, productivity-focused Git TUI
- ⬢ [git-delta](https://github.com/dandavison/delta) — syntax-highlighting pager for git diffs (used by git and lazygit)
- 📦 [git-extras](https://github.com/tj/git-extras) — collection of extra git utilities (`git summary`, `git ignore`, `git undo`…)
- 📦 [gitflow](https://github.com/nvie/gitflow/wiki/Linux) — Git Flow branching extensions (feature/release/hotfix)

### Containers & Kubernetes

- ⬢ [lazydocker](https://github.com/jesseduffield/lazydocker) — TUI for Docker/Compose (containers, logs, stats)
- ⬢ [ctop](https://github.com/bcicen/ctop) — `top` for containers, with real-time metrics
- ⬢ [k9s](https://github.com/derailed/k9s) — TUI to manage and navigate Kubernetes clusters
- ⬢ [kubectl](https://kubernetes.io/docs/reference/kubectl/) — the Kubernetes command-line client
- 🔧 [docker-ce](https://docs.docker.com/engine/) — Docker Engine; installed only on native Linux (non-WSL); macOS/WSL use Docker Desktop

### Cloud & IaC

- ⬢ [terraform](https://github.com/hashicorp/terraform) — infrastructure as code (HashiCorp; BSL license)
- 🔧 [aws-cli](https://aws.amazon.com/cli/) — AWS command-line interface (v2)
- 🔧 [gcloud](https://cloud.google.com/sdk/gcloud) — Google Cloud CLI

### System & disk

- 📦 [htop](https://htop.dev/) — interactive process monitor
- 📦 [btop](https://github.com/aristocratos/btop) — resource monitor (CPU/mem/net/disk/processes) TUI; replaces bpytop/glances
- 📦 [ncdu](https://dev.yorhel.nl/ncdu) — interactive disk usage analyzer (`du` in ncurses)
- ⬢ [duf](https://github.com/muesli/duf) — modern `df`: disk usage and partitions in colored tables
- ⬢ [dysk](https://github.com/Canop/dysk) — disk usage and mounted filesystems in a detailed table

### Network

- ⬢ [doggo](https://github.com/mr-karan/doggo) — friendly DNS client (a modern `dig`); replaces dog
- 📦 [mtr](https://www.bitwizard.nl/mtr/) — network diagnostic combining `ping` + `traceroute` (`mtr-tiny` on Linux)
- ⬢ [cloudflare-speed-cli](https://github.com/kavehtehrani/cloudflare-speed-cli) — internet speed test via Cloudflare's network (TUI)
- ⬢ [miniserve](https://github.com/svenstaro/miniserve) — tiny HTTP file server with a browser upload UI
- ⬢ [fortio](https://github.com/fortio/fortio) — HTTP/gRPC load testing tool with a web UI
- ⬢ [globalping](https://github.com/jsdelivr/globalping-cli) — run network measurements (ping/traceroute/DNS/HTTP) from a global network of probes
- ⬢ [ngrok](https://ngrok.com) — secure tunnels exposing a local port to the internet (run `ngrok config add-authtoken <token>` once; the token is a secret and is **not** stored in this repo)

### Data (JSON/YAML)

- 📦 [jq](https://jqlang.github.io/jq/) — command-line JSON processor
- ⬢ [yq](https://github.com/mikefarah/yq) — YAML/JSON/XML processor (the "`jq` for YAML")
- ⬢ [jnv](https://github.com/ynqa/jnv) — interactive JSON explorer with live `jq` filters

### Editor & environment

- ⬢ [micro](https://github.com/micro-editor/micro) — modern terminal editor with GUI-style shortcuts
- 📦 [direnv](https://direnv.net/) — loads/unloads environment variables per directory (via `.envrc`)
- ⬢ [mise](https://github.com/jdx/mise) — polyglot runtime/tool version manager (node/python/go/rust/ruby…); asdf-compatible, reads `.tool-versions`/`mise.toml`. Default versions in `~/.config/mise/config.toml`; run `mise install` to fetch them

### AI coding

- 🔧 [kiro-cli](https://kiro.dev/docs/cli/) — AI coding assistant in the terminal (successor of the Amazon Q CLI)
- 🔧 [claude-code](https://docs.anthropic.com/en/docs/claude-code) — Anthropic's terminal-native agentic coding tool (`claude`)
- 🔧 [codex](https://github.com/openai/codex) — OpenAI's local coding agent CLI
- 🔧 [opencode](https://opencode.ai) — open-source AI coding agent for the terminal

## Shortcuts

- <kbd>Ctrl</kbd> + <kbd>R</kbd>: fuzzy history search
- <kbd>Ctrl</kbd> + <kbd>T</kbd>: paste a file/dir path into the command line
- <kbd>Alt</kbd> + <kbd>C</kbd>: fuzzy `cd` into a subdirectory
- <kbd>Alt</kbd> + <kbd>G</kbd>: jump to a bookmarked directory (fzf-marks; `mark` to add, `dmark` to delete)
- <kbd>TAB</kbd>: fuzzy completion menu (fzf-tab) — TAB drills into the selection and keeps completing, <kbd>Enter</kbd> accepts; <kbd>Alt</kbd>+<kbd>P</kbd> toggles preview, `[`/`]` switch group
- `**` + <kbd>TAB</kbd>: fzf completion trigger for the current command
- `psf`: fuzzy process list (fzf over `ps`, sorted by CPU) — type to filter by name/user/PID, <kbd>SPACE</kbd> multi-select, <kbd>Enter</kbd> copies PID(s), <kbd>Ctrl</kbd>+<kbd>K</kbd> kills selection, <kbd>Ctrl</kbd>+<kbd>R</kbd> reloads

## Aliases
- `readme`: See this file
- `ls`: `eza`
- `bat`: `batcat` (Ubuntu only)
- `fd`: `fdfind` (Ubuntu only)
- `m`: `micro`
- `lg`: `lazygit`
- `cm`: `chezmoi`
- `k`: `kiro-cli`
- `walk`: file browser with icons

## Scripts
- `preview`: See the contents of a file or a dir

## Useful links
- [The 50 Most Useful Linux Commands To Run in the Terminal](https://www.ubuntupit.com/best-linux-commands-to-run-in-the-terminal/)
- [Unix System Monitoring and Diagnostic CLI Tools](https://monadical.com/posts/system-monitoring-tools.html)
- [Linux Performance](https://www.brendangregg.com/linuxperf.html)
