#!/usr/bin/env bash

# Git related
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gl='git log'
alias gsb='git show-branch'
alias gco='git checkout'
alias gg='git grep'
alias gk='gitk --all'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gcp='git cherry-pick'
alias grm='git rm'

# Loading git custom command
if [ -f "$AWE_PLUGIN_CURRENT_FOLDER/AweGit.sh" ]; then
    alias git="$AWE_PLUGIN_CURRENT_FOLDER/AweGit.sh"
    export AWE_EXT_AWEGIT_LOG_FILE="$AWE_PLUGIN_CURRENT_CACHE_FOLDER/branch_history_$(date +"%m_%d_%Y").log"
else
    echo "AweGit ERROR: incorrect alias for better git"
fi