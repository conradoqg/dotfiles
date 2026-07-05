# mise — polyglot runtime/tool version manager (https://mise.jdx.dev).
# Activation hooks precmd/chpwd to put the right versions on PATH, based on the
# global ~/.config/mise/config.toml and per-project .tool-versions / mise.toml.
# Guarded so shells on machines without mise still start cleanly.
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi
