
export EDITOR=nvim
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.cargo/bin:$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export SQLITE_VEC_PATH="$HOME/.local/lib/vec0.so"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.config/memory-tools:$PATH"

HISTORY=50000
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Essential options:
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS


if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-syntax-highlighting
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit load zsh-users/zsh-completions
zinit load agkozak/zsh-z
zinit load junegunn/fzf
zinit load rupa/z
zinit load zsh-users/zsh-history-substring-search
zinit load hlissner/zsh-autopair

fzf-history-widget() {
    BUFFER=$(fc -rl 1 | fzf --no-sort | sed 's/^[ 0-9]*//')
    CURSOR=$#BUFFER
}
zle -N fzf-history-widget

bindkey '^R' fzf-history-widget
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
bindkey '^F' forward-word
bindkey '^B' backward-word
bindkey '^D' kill-word

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

alias s="source ~/.zshrc ~/.config/starship/starship.conf ~/.config/tmux/tmux.conf ~/.config/nvim/init.lua && setxkbmap -option ctrl:nocaps -layout us && i3-msg restart >/dev/null 2>&1 && echo 'Sourced zsh, tmux, nvim, i3, xkbmap, starship'"
alias v="nvim"
alias c="clear"
alias x="exit"
# alias sd="cd ~ && cd \$(find * -type d | fzf)"
alias ls='eza -a --long --sort type --no-user --icons --group-directories-first'
alias lst='eza --icons --group-directories-first --tree'
# alias lc="git ls-files -z | xargs -0 wc -l 2>/dev/null"
# alias grep='rg'
# alias search='rg'
alias tp='trash-put'
alias del='trash-put'
alias restore='trash-restore'
alias clickKill="xdotool selectwindow | xargs -I WID i3-msg \"[id=WID] kill\""
alias wifiConnect='nmcli dev wifi list | fzf | awk "{printf \"%s\", \$2}" | xargs -I {} nmcli dev wifi connect "{}"'
alias k3000='sudo fuser -k 3000/tcp'

alias rcloneBackupDocuments="rclone sync -v --exclude-from ~/.config/rclone/documents-backup-exclude.txt ~/Documents/ google_drive:DOCUMENTS"
alias rcloneBackupConfig="rclone sync -v --filter-from ~/.config/rclone/config-backup-filter.txt ~/.config/ google_drive:CONFIG"
alias rcloneBackupClaude="rclone sync -v --exclude-from ~/.config/rclone/claude-backup-exclude.txt ~/.claude/ google_drive:CLAUDE"
alias rcBACKUP="rcloneBackupDocuments && rcloneBackupConfig && rcloneBackupClaude"
alias rcloneSetup="rclone config reconnect google-drive: || rclone config "
alias rcloneFavoritesAdd="rclone move ~/Documents/prod/favorites/ google_drive:favorites_prod"

alias musicExport="rclone copy -v ~/Documents/prod/drive_workspace/ google_drive:music/workspace/"
alias musicImport="rclone copy -v google_drive:music/workspace ~/Documents/prod/drive_workspace"
alias noteSync="cd ~/Documents/code/simplenote_sync && uv run python simplenote_sync.py"

alias gd='echo -e "\033[1mStaged changes:\033[0m" && git diff --cached --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUnstaged changes:\033[0m" && git diff --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUntracked files:\033[0m" && git ls-files --others --exclude-standard | while read file; do lines=$(wc -l < "$file"); printf "\033[32m+%s\033[0m %s\n" "$lines" "$file"; done'
alias gdp='git --no-pager diff HEAD'
alias gi='git init && touch temp && git add . && git commit -m "init" && git remote add origin https://github.com/alexpetro47/$(basename $(pwd)).git && gh repo create $(basename $(pwd)) --private && git push && rm temp && git status'
alias cl="claude"
alias clm="claude mcp list"
alias clr="claude -r"
# alias vid="openshot-qt"
# alias sql="sqlitebrowser &"
# alias db="dbgate &"

alias puml="/usr/bin/java -jar /home/alexpetro/Documents/code/plantuml/plantuml.jar" 
alias j1="clear; cbonsai -l -i -S" 

alias br='bun dev '
alias bc='rm -rf .next && echo "nextjs cache and error log cleared"'
alias bC='rm -rf .next node_modules bun.lockb && bun install && echo "nextjs cache and error log cleared"'
alias bi='bun install'
alias bb='bun --bun run build'
alias bl='bun --bun run lint'
alias bt='npx @agentdeskai/browser-tools-server@latest'

alias "uv run"="PYTHONPATH=. uv run"

alias uvs='uv sync'
alias uvr='uv run'
alias uva='uv add'
alias uvd='uv remove'
alias uvi='uv init'
alias uvl='uv lock'
alias uvt='uv tree'
alias jl='jupyter-lab'


# Memory search tool from memorcy_mcp project
memory() {
  ORIGINAL_CWD=$(pwd) uv run --directory /home/alexpetro/Documents/code/memory_mcp python -c "
import os
import sys
if 'ORIGINAL_CWD' in os.environ:
  os.chdir(os.environ['ORIGINAL_CWD'])
sys.path.insert(0, '/home/alexpetro/Documents/code/memory_mcp')
exec(open('/home/alexpetro/Documents/code/memory_mcp/cli.py').read())
" "$@"
}

# Shorthand aliases
alias sem-index='memory index $(pwd) --verbose'
alias sem-search='memory search'




### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 
[ -s "/home/alexpetro/.bun/_bun" ] && source "/home/alexpetro/.bun/_bun"
[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver >/dev/null 2>&1


