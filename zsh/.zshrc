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

#rust and cargo path
export PATH="$HOME/.cargo/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k" 
HISTORY=10000
SAVEHIST=10000

touch .hushlogin

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# source <(fzf --zsh) # need go installed as a dependency, this is for keybingds and auto comp

alias s="source ~/.zshrc ~/.config/tmux/tmux.conf ~/.config/alacritty/alacritty.toml ~/.config/nvim/init.lua"
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
# alias ip="ipconfig getifaddr en0" #get ip address
alias j1="clear; cbonsai -l -i -S" #ascii tree, clearing messy term beforehand
# alias j3="macchina" #system info

#fuzzy finder source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# clear
# macchina
