# FZF

# fzf's command
#export FZF_DEFAULT_COMMAND="fdfind -c always --hidden --follow --exclude '.git' --exclude 'node_modules'"
# CTRL-T's command
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# ALT-C's command
#export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# Default options
#export FZF_DEFAULT_OPTS="
#--info=inline
#--height=80%
#--multi
#--preview-window=:hidden
#--preview '([[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
#--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
#--prompt='∼ ' --pointer='▶' --marker='✓'
#--bind '?:toggle-preview'
#--bind 'ctrl-a:toggle-all'
#--bind 'ctrl-e:execute:(echo {+} | xargs -o vim > /dev/tty)'
#--bind 'tab:accept'
#--bind 'space:toggle'
#--ansi
#"

# FZF-TAB
setopt glob_dots

zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' 'space:toggle'

