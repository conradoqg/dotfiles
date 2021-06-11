
# FZF-HISTORY

#--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
#--bind 'ctrl-e:execute:(echo {+} | xargs -o vim > /dev/tty)'

export FZF_CTRL_R_OPTS="
	--height 30%
	--header='tab:accept'
	--bind 'tab:accept'
	--prompt='∼ '
	--pointer='▶'
	--reverse	
"

# FZF-**

export FZF_COMPLETION_OPTS="
	--height 30%
	--header 'tab:accept, space:toggle, ctrl-a:toggle-all, ctrl-v:preview'
	--preview-window=:hidden
	--preview 'preview {}'
	--bind 'ctrl-v:toggle-preview'
	--bind 'ctrl-a:toggle-all'
	--bind 'tab:accept'
	--bind 'space:toggle'
	--prompt='∼ '
    --pointer='▶'
	--marker='✓'
	--ansi
"

_fzf_compgen_path() {
  fdfind --hidden --follow -c always --exclude ".git" . "$1"  
}

_fzf_compgen_dir() {
  fdfind --type d --hidden -c always --follow --exclude ".git" . "$1"
}

# FZF-TAB
setopt glob_dots
zstyle ':fzf-tab:*' fzf-bindings \
	'ctrl-v:toggle-preview' \
	'ctrl-a:toggle-all' \
	'tab:accept' \
	'space:toggle'
zstyle ':fzf-tab:*' fzf-flags \
	'--height=30%' \
	'--header=tab:accept, space:toggle, ctrl-a:toggle-all, ctrl-v:preview' \
	'--preview-window=:hidden' \
	'--prompt=∼ ' \
	'--pointer=▶' \
	'--marker=✓'
zstyle ':fzf-tab:complete:*' fzf-preview 'preview $realpath'

# FZF-MARKS
export FZF_MARKS_COMMAND="fzf --height 40% --reverse --prompt='∼ ' --pointer='▶' --marker='✓'"
