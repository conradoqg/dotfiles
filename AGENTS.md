# Repository Guidelines

## Project Structure & Module Organization

This repository uses chezmoi to manage personal dotfiles.

- `dot_*` and `private_dot_config/` map to files under `$HOME`.
- `dot_oh-my-zsh-custom/` contains custom Zsh aliases and configuration.
- `dot_local/bin/` contains executable helper scripts, such as `preview` and `sync-skills`.
- `.chezmoi*.tmpl` files define machine detection, external downloads, ignores, and removals.
- `.chezmoiscripts/` contains idempotent package and CLI provisioning scripts.
- `test/` contains the Docker-based fresh-install harness; `README.md` documents setup.

## Build, Test, and Development Commands

Run these commands from the repository root:

```sh
chezmoi diff                         # Review the rendered changes
chezmoi apply                        # Apply changes to the current home directory
./test/run-matrix.sh                 # Test Linux amd64 and arm64
./test/run-matrix.sh linux/amd64     # Test only amd64
chezmoi verify --exclude=scripts     # Verify applied files
```

For quick validation, run `git diff --check` and check shell files with `zsh -n` or `bash -n`. The Docker build is the integration test for clean installation and idempotency.

## Coding Style & Naming Conventions

Keep shell scripts portable and idempotent. Bash provisioning scripts use `set -euo pipefail`; preserve existing quoting and error handling. Use two-space indentation in Zsh and four spaces in Bash blocks. Follow chezmoi names: `dot_` for home files, `private_dot_` for private config, `executable_` for executable targets, and `run_onchange_<timing>-<purpose>.sh.tmpl` for hooks. No formatter or linter is configured; use syntax checks and focused diffs.

## Testing Guidelines

Changes affecting installation, templates, packages, or downloads should pass the full matrix when Docker and QEMU are available. Shell-only changes should pass the relevant syntax check and `chezmoi verify`. There is no coverage threshold.

## Commit & Pull Request Guidelines

Use short, imperative commit subjects. The history mixes plain subjects with Conventional Commit-style prefixes such as `fix(fzf): ...`, `feat(cli): ...`, and `docs: ...`; prefer the scoped form for focused changes. Pull requests should describe affected platforms and rendered files, list validation commands, and call out behavior or dependency changes. Include terminal screenshots only for relevant visual changes.

## Security & Configuration Tips

Never commit credentials or tokens. `CHEZMOI_GITHUB_ACCESS_TOKEN` may be supplied through the environment for CI rate limits; service tokens such as ngrok auth tokens belong in local configuration. Use `DOTFILES_NO_PROVISION=1` to skip heavyweight provisioners during core apply tests.
