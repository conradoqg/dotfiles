# ============================================================================
# fzf configuration
# ============================================================================

# fd binary differs by platform (fdfind on Ubuntu/apt, fd on macOS/brew).
# If neither is installed, fall back to fzf's built-in file walker (fzf >=0.53).
if (( $+commands[fdfind] )); then _FZF_FD=fdfind
elif (( $+commands[fd] )); then _FZF_FD=fd
else _FZF_FD=""; fi

# --- Global defaults (inherited by every fzf invocation) --------------------
# Adaptive height: the finder grows with the results up to the full screen and
# shrinks when there are few, so it always uses the space below the prompt
# without wasting it. Results render below the prompt (reverse). Unified look.
export FZF_DEFAULT_OPTS="
	--height=~100%
	--layout=reverse
	--border
	--prompt='∼ '
	--pointer='▶'
	--marker='✓'
	--ansi
"
# Use fd as the source only when available; otherwise fzf's built-in walker.
[[ -n "$_FZF_FD" ]] && export FZF_DEFAULT_COMMAND="$_FZF_FD --type f --hidden --follow --exclude .git"

# --- Ctrl-R: history (the custom widget lives in fzf-history.zsh) -----------
# Only the context-specific bits here; height/layout/look come from the global.
export FZF_CTRL_R_OPTS="
	--header='tab: accept'
	--bind 'tab:accept'
"

# --- Ctrl-T (paste path) and Alt-C (cd) -------------------------------------
[[ -n "$_FZF_FD" ]] && export FZF_CTRL_T_COMMAND="$_FZF_FD --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
	--preview 'preview {}'
	--bind 'alt-p:toggle-preview'
	--header='ctrl-t: paste path (alt-p: toggle preview)'
"
[[ -n "$_FZF_FD" ]] && export FZF_ALT_C_COMMAND="$_FZF_FD --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="
	--preview 'eza -la --icons --color=always {} 2>/dev/null || ls -la {}'
	--bind 'alt-p:toggle-preview'
	--header='alt-c: cd (alt-p: toggle preview)'
"
# Enable fzf's own Ctrl-T / Alt-C widgets. This file is sourced before
# fzf-history.zsh, which re-binds Ctrl-R to the custom history widget, so the
# custom Ctrl-R keeps winning.
if fzf --zsh >/dev/null 2>&1; then
	source <(fzf --zsh)
fi
# fzf's completion binds TAB to fzf-completion, clobbering fzf-tab. Hand TAB
# back to fzf-tab so plain TAB opens its menu (with previews); fzf-tab then
# falls back to fzf-completion for the ** trigger. Ctrl-T/Alt-C stay on fzf.
(( $+functions[enable-fzf-tab] )) && enable-fzf-tab

# --- `**<TAB>` completion ----------------------------------------------------
export FZF_COMPLETION_OPTS="
	--header 'tab: accept · space: toggle · ctrl-a: all · alt-p: preview'
	--preview-window=:hidden
	--preview 'preview {}'
	--bind 'alt-p:toggle-preview'
	--bind 'ctrl-a:toggle-all'
	--bind 'tab:accept'
	--bind 'space:toggle'
"
if [[ -n "$_FZF_FD" ]]; then
	_fzf_compgen_path() { $_FZF_FD --hidden --follow -c always --exclude .git . "$1"; }
	_fzf_compgen_dir()  { $_FZF_FD --type d --hidden --follow -c always --exclude .git . "$1"; }
fi

# --- fzf-tab (the TAB menu) --------------------------------------------------
setopt glob_dots

# Let fzf-tab fully take over the completion menu.
zstyle ':completion:*' menu no
# Group headers, and let fzf-tab switch between candidate groups with [ / ].
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' switch-group '[' ']'
# Inherit the global FZF_DEFAULT_OPTS (border, prompt, pointer, colors) so the
# menu matches Ctrl-T/Alt-C. fzf-tab still computes its own height (grows with
# the results, capped at ~2/3 of the screen).
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# TAB accepts the highlighted candidate and immediately continues completion
# (e.g. drills into the selected directory); Enter accepts without continuing.
zstyle ':fzf-tab:*' continuous-trigger 'tab'

zstyle ':fzf-tab:*' fzf-bindings \
	'alt-p:toggle-preview' \
	'ctrl-a:toggle-all' \
	'space:toggle'
zstyle ':fzf-tab:*' fzf-flags \
	'--header=tab: continue · enter: accept · space: mark · ctrl-a: all · alt-p: preview' \
	'--preview-window=:hidden'

# Context-aware previews (shown on Alt-P; the (kill|ps) one is always visible).
zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
	'eza -la --icons --color=always $realpath 2>/dev/null || ls -la $realpath'
# Show the directory preview by default for cd (Alt-P still toggles it), and
# give cd full adaptive height (~100%), overriding fzf-tab's 2/3 cap. fzf-flags
# is appended last, so its --height wins over fzf-tab's computed value.
zstyle ':fzf-tab:complete:cd:*' fzf-flags \
	'--height=~100%' \
	'--header=tab: continue · enter: accept · space: mark · ctrl-a: all · alt-p: toggle preview' \
	'--preview-window=right:55%:wrap'
zstyle ':fzf-tab:complete:git-*:*' fzf-preview \
	'git -c color.ui=always log --oneline -20 -- $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
	'ps --pid=$word -o pid,user,cmd --no-headers -ww 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags \
	'--header=tab: continue · enter: accept · space: mark · ctrl-a: all · alt-p: preview' \
	'--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:(export|unset|expand):*' fzf-preview 'echo ${(P)word} 2>/dev/null'

# --- fzf-marks (bookmarks; the plugin lives in fzf-marks.zsh) ----------------
# Set here (before the plugin) so it inherits the global adaptive height.
export FZF_MARKS_COMMAND="fzf"
# Jump-to-bookmark key. The default Ctrl-G is stolen by VS Code (go to line),
# so use Alt-G (^[g) instead.
export FZF_MARKS_JUMP='^[g'

# --- Path editing: Alt+Backspace deletes one path segment (go up a level) ----
# Companion to TAB drilling: if you drilled too deep, cancel the menu (Esc) and
# press Alt+Backspace to drop the last "/segment", then TAB to re-complete from
# the parent. It's a normal backward-kill-word with '/' treated as a boundary.
backward-kill-dir() {
	local WORDCHARS=${WORDCHARS//[\/]/}
	zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir   # Alt+Backspace (DEL)
bindkey '^[^H' backward-kill-dir   # Alt+Backspace (some terminals send ^H)