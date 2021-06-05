# FZF

#--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
#--bind 'ctrl-e:execute:(echo {+} | xargs -o vim > /dev/tty)'

export FZF_CTRL_T_COMMAND="fdfind --hidden --follow -c always --exclude '.git' --exclude 'node_modules'"

export FZF_CTRL_T_OPTS="
	--preview-window=:hidden
	--preview 'preview {}'
	--bind '?:toggle-preview'
	--bind 'ctrl-a:toggle-all'
	--bind 'tab:accept'
	--bind 'space:toggle'
	--prompt='∼ '
    --pointer='▶'
	--marker='✓'
	--ansi
"

export FZF_CTRL_R_OPTS="
	--bind 'tab:accept'
	--prompt='∼ '
	--pointer='▶'
	--reverse
"

export FZF_ALT_C_COMMAND='fdfind -t d --hidden --follow -c always --exclude .git'

export FZF_ALT_C_OPTS="$FZF_CTRL_T_OPTS"

export FZF_ALT_E_COMMAND='fdfind -t f --hidden --follow -c always'

export FZF_ALT_E_OPTS="$FZF_CTRL_T_OPTS"

export FZF_COMPLETION_OPTS="$FZF_CTRL_T_OPTS"

_fzf_compgen_path() {
  fdfind --hidden --follow -c always --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fdfind --type d --hidden -c always --follow --exclude ".git" . "$1"
}

# FZF-TAB
setopt glob_dots
zstyle ':fzf-tab:*' fzf-bindings \
	'?:toggle-preview' \
	'ctrl-a:toggle-all' \
	'tab:accept' \
	'space:toggle'
zstyle ':fzf-tab:*' fzf-flags \
	'--preview-window=:hidden' \
	'--prompt=∼ ' \
	'--pointer=▶' \
	'--marker=✓'
zstyle ':fzf-tab:complete:*' fzf-preview 'preview $realpath'
