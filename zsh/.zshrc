
export ZSH="/home/alexpetro/.oh-my-zsh"
export EDITOR=nvim
export PGDATABASE=postgres #for default postgres entry
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.cargo/bin:$BUN_INSTALL/bin:$PATH"

HISTORY=25000
SAVEHIST=25000
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"

alias s="source ~/.zshrc ~/.config/tmux/tmux.conf ~/.config/nvim/init.lua && setxkbmap -option ctrl:nocaps -layout us && i3-msg restart >/dev/null 2>&1 && echo 'Sourced zsh, tmux, nvim, i3, xkbmap'"
alias v="nvim"
alias c="clear"
alias x="exit"
alias sd="cd ~ && cd \$(find * -type d | fzf)"
alias ls='eza -a --long --sort type --no-user --icons --group-directories-first'
alias lsr='eza --icons --group-directories-first --tree'
alias lc="git ls-files | grep -v '^project_context/' | xargs wc -l 2>/dev/null"
alias gd='echo -e "\033[1mStaged changes:\033[0m" && git diff --cached --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUnstaged changes:\033[0m" && git diff --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUntracked files:\033[0m" && git ls-files --others --exclude-standard | while read file; do lines=$(wc -l < "$file"); printf "\033[32m+%s\033[0m %s\n" "$lines" "$file"; done'
alias gdp='git --no-pager diff'
alias nc='rm -rf .next && : > npm_errors.log && echo "nextjs cache and error log cleared"'
alias nC='rm -rf node_modules && rm package-lock.json && npm cache clean --force && npm install'
alias nr='npm run dev '
alias nb='npm run build --debug'
alias nl='npm run lint'
alias bt='npx @agentdeskai/browser-tools-server@latest'
alias sv="source .venv/bin/activate && echo 'venv activated'" 
alias puml="/usr/bin/java -jar /home/alexpetro/Documents/code/plantuml/plantuml.jar" 
alias rcloneBackupDocuments="rclone sync -v --exclude-from ~/.config/rclone/backup-exclude.txt ~/Documents/ google-drive:DOCUMENTS-RCLONE-BACKUP"
alias rcloneBackupConfig="rclone sync -v --filter-from ~/.config/rclone/config-backup-filter.txt ~/.config/ google-drive:CONFIG-RCLONE-BACKUP"
alias rcloneSetup="rclone config reconnect google-drive:"
alias musicExport="rclone sync -v ~/Documents/prod/exports/ google-drive:music/workspace/alex-exports"
alias musicImport="rclone sync -v google-drive:music/workspace/gill-exports ~/Documents/prod/imports/"
alias clickKill="xdotool selectwindow | xargs -I WID i3-msg \"[id=WID] kill\""
alias wifiConnect='nmcli dev wifi list | fzf | awk "{printf \"%s\", \$2}" | xargs -I {} nmcli dev wifi connect "{}"'
alias pipIR="uv pip install -r requirements.txt"
alias j1="clear; cbonsai -l -i -S" 

bindkey '^R' fzf-history-widget
fzf-history-widget() {
    BUFFER=$(fc -rl 1 | fzf | sed 's/^[ 0-9]*//')
    CURSOR=$#BUFFER
    zle accept-line
}
zle -N fzf-history-widget

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 
[ -s "/home/alexpetro/.bun/_bun" ] && source "/home/alexpetro/.bun/_bun"

