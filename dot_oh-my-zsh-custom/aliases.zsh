alias readme="bat ~/README.md"
alias ls="eza -la --time-style long-iso --icons"
alias m="micro"
alias lg="lazygit"
alias cm="chezmoi"
alias walk="walk --icons"

# Portabilidade: no Ubuntu os binários chamam-se batcat/fdfind; no macOS/brew, bat/fd.
command -v batcat >/dev/null 2>&1 && alias bat="batcat"
command -v fdfind >/dev/null 2>&1 && alias fd="fdfind"
