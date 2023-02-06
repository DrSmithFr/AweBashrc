#!/usr/bin/env bash

# misspell helper
alias gti=git
alias gto=git
alias got=git

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
    export AWE_EXT_AWEGIT_LOG_DIR="$AWE_PLUGIN_CURRENT_CACHE_FOLDER/$USER"
else
    echo "AweGit ERROR: incorrect alias for better git"
fi
