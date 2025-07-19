# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# npm global install locations via nvm
export PATH="$HOME/.config/nvm/versions/node/v24.0.2/bin:$PATH" # Add repomix and other global npm binaries to PATH

# Path to your oh-my-zsh installation.
# linux: "/home/username/.oh-my-zsh"
export ZSH="/home/alexpetro/.oh-my-zsh"
export EDITOR=nvim
export VISUAL=nvim
export PGDATABASE=postgres #for default postgres entry

export N8N_RUNNERS_ENABLED=true

# auto export env variables into my path
# includes: gemini api key, 
set -a
source /home/alexpetro/.config/.env
set +a 

#for debugpy path
export PATH="$HOME/.debugpy-env/bin:$PATH"

#rust and cargo path
export PATH="$HOME/.cargo/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k" 
HISTORY=25000
SAVEHIST=25000

touch .hushlogin

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# source <(fzf --zsh) # need go installed as a dependency, this is for keybingds and auto comp

alias s="source ~/.zshrc ~/.config/tmux/tmux.conf ~/.config/nvim/init.lua && setxkbmap -option ctrl:nocaps -layout us && i3-msg restart >/dev/null 2>&1 && echo 'Sourced zsh, tmux, nvim, i3, xkbmap'"
alias v="nvim"
alias c="clear"
alias x="exit"
# alias p="psql"
# alias t="tmux attach" 
# alias k="killall tmux"
alias sd="cd ~ && cd \$(find * -type d | fzf)" #search to cd
alias pe="source myEnv/bin/activate" #activate python env
alias de="deactivate" #deactivate python env
alias f="fzf"
alias ls="ls -Glah" #improved ls
alias gt="echo -e '\n' && git ls-files | cpio -pd --quiet .git-tree && tree .git-tree && rm -rf .git-tree"
alias lc="wc -l **/*(.D) 2>/dev/null" #count lines in all files in dir
alias gd='echo -e "\033[1mStaged changes:\033[0m" && git diff --cached --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUnstaged changes:\033[0m" && git diff --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUntracked files:\033[0m" && git ls-files --others --exclude-standard | while read file; do lines=$(wc -l < "$file"); printf "\033[32m+%s\033[0m %s\n" "$lines" "$file"; done'
alias nc='rm -rf .next && : > npm_errors.log && echo "nextjs cache and error log cleared"'
alias nC='rm -rf node_modules && rm package-lock.json && npm cache clean --force && npm install'
alias nr='npm run dev '
alias nb='npm run build --debug'
alias nl='npm run lint'
alias bt='npx @agentdeskai/browser-tools-server@latest' #start browser tools server
alias sv="source venv/bin/activate && echo 'venv activated'" #activate venv
alias t="trash"
alias puml="/usr/bin/java -jar /home/alexpetro/Documents/code/plantuml/plantuml.jar" #plantuml
alias a="aider"
alias ainit="mkdir .aider && cd .aider && touch .aiderignore .aider.chat.history.md .aider.input.history && cd .."
alias as="apt list | fzf" #search apt packages
alias rcloneBackupDocuments="rclone sync -v --exclude-from ~/.config/rclone/backup-exclude.txt ~/Documents/ google-drive:DOCUMENTS-RCLONE-BACKUP"
alias rcloneBackupConfig="rclone sync -v --filter-from ~/.config/rclone/config-backup-filter.txt ~/.config/ google-drive:CONFIG-RCLONE-BACKUP"
alias rcloneSetup="rclone config reconnect google-drive:"
alias musicExport="rclone sync -v ~/Documents/prod/exports/ google-drive:music/workspace/alex-exports"
alias musicImport="rclone sync -v google-drive:music/workspace/gill-exports ~/Documents/prod/imports/"
alias Import="rclone sync -v google-drive:IMPORTS-EXPORTS ~/Documents/notes/drive-imports/ && cd ~/Documents/notes/drive-imports && find /home/alexpetro/Documents/notes/drive-imports/ -type f -name '*.heic' -print0 | xargs -0 -n 1 /home/alexpetro/Documents/code/file-converters/venv/bin/python3 /home/alexpetro/Documents/code/file-converters/heic-png.py && rclone sync -v ~/Documents/notes/drive-imports/ google-drive:IMPORTS-EXPORTS && ls " 
alias Export="rclone sync -v ~/Documents/notes/drive-imports/ google-drive:IMPORTS-EXPORTS"
alias clickKill="xdotool selectwindow | xargs -I WID i3-msg \"[id=WID] kill\""
# removed - performance degradation 
# alias clearSWP="sudo swapoff -a && sudo swapon -a"
# alias clearCaches="sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches"
# alias Clear="clearCaches && i3-msg restart && clear" #clear screen and caches
alias refresh="sudo apt update && sudo apt upgrade && sudo apt autoremove --purge && clearSWP && clearCaches"
alias wifiConnect='nmcli dev wifi list | fzf | awk "{printf \"%s\", \$2}" | xargs -I {} nmcli dev wifi connect "{}"'
alias pipIR="pip install -r requirements.txt"
alias dockerR="docker compose down && docker compose up -d"
alias svg="flatpak run com.boxy_svg.BoxySVG &"

# update nvim (built from source)
# ends up in /usr/local/bin/nvim
alias vu="cd ~/neovim && git pull && make distclean && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install"


alias j1="clear; cbonsai -l -i -S" 
alias j2="clear; pipes -C -R -s 15 -t 3" 
# alias j3="clear; neofetch"


# Use fzf for history search
bindkey '^R' fzf-history-widget

# Function to integrate fzf with history
fzf-history-widget() {
    BUFFER=$(fc -rl 1 | fzf | sed 's/^[ 0-9]*//')
    CURSOR=$#BUFFER
    zle accept-line
}
zle -N fzf-history-widget




#fuzzy finder source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# this automatically exports any environment variables you have in ~/.config/.env
# such as API keys for llm's etc
if [ -f ~/.config/.env ]; then
  source ~/.config/.env
fi


# clear
# macchina

# Created by `pipx` on 2024-12-20 19:53:49
export PATH="$PATH:/home/alexpetro/.local/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alexpetro/google-cloud-sdk/path.zsh.inc' ]; then . '/home/alexpetro/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alexpetro/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/alexpetro/google-cloud-sdk/completion.zsh.inc'; fi


# bun completions
[ -s "/home/alexpetro/.bun/_bun" ] && source "/home/alexpetro/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
