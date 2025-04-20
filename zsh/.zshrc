# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# linux: "/home/username/.oh-my-zsh"
export ZSH="/home/alexpetro/.oh-my-zsh"
export EDITOR=nvim
export PGDATABASE=postgres #for default postgres entry

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

alias s="source ~/.zshrc ~/.config/tmux/tmux.conf  ~/.config/nvim/init.lua && i3-msg restart >/dev/null 2>&1 && echo 'Sourced zsh, tmux, nvim, i3'"
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
alias lc="wc -l * 2>/dev/null" #count lines in all files in dir
alias gd='echo -e "\033[1mStaged changes:\033[0m" && git diff --cached --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'' && echo -e "\n\033[1mUnstaged changes:\033[0m" && git diff --numstat | awk '\''{printf "\033[32m+%s\033[0m \033[31m-%s\033[0m %s\n", $1, $2, $3}'\'''


# alias ip="ipconfig getifaddr en0" #get ip address
alias j1="clear; cbonsai -l -i -S" #ascii tree, clearing messy term beforehand
alias j2="clear; neofetch" #ascii tree, clearing messy term beforehand
# alias j3="macchina" #system info


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
