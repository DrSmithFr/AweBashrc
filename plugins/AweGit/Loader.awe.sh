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

# git contrib
function git_contrib()
{
  for author in $(command git log --all --no-merges --format="%ae" | sort | uniq); do
    echo -e "\e[1;33m$author\e[m:"
    command git log --all --no-merges --shortstat --author="$author" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed: ", files, "\nlines inserted: ", inserted, "\nlines deleted: ", deleted }'
    echo ""
  done
}

function git_contrib_since()
{
  for author in $(command git log --all --no-merges --format="%ae" --since="$1" | sort | uniq); do
    echo -e "\e[0;33m$author\e[m:"
    command git log --all --no-merges --shortstat --author="$author" --since="$1" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed: ", files, "\nlines inserted: ", inserted, "\nlines deleted: ", deleted }'
    echo ""
  done
}

# Loading git custom command
if [ -f "$AWE_PLUGIN_CURRENT_FOLDER/AweGit.sh" ]; then
    alias git="$AWE_PLUGIN_CURRENT_FOLDER/AweGit.sh"
    export AWE_EXT_AWEGIT_LOG_DIR="$AWE_PLUGIN_CURRENT_CACHE_FOLDER/$USER"
else
    echo "AweGit ERROR: incorrect alias for better git"
fi
