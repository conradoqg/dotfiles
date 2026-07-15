alias readme="bat ~/README.md"
alias ls="eza -la --time-style long-iso --icons"
alias m="micro"
alias lg="lazygit"
alias cm="chezmoi"
alias ki="kiro-cli"
alias walk="walk --icons"
alias ngrok-here='ngrok http file://$(pwd)'

# Portability: on Ubuntu the binaries are batcat/fdfind; on macOS/brew, bat/fd.
command -v batcat >/dev/null 2>&1 && alias bat="batcat"
command -v fdfind >/dev/null 2>&1 && alias fd="fdfind"
