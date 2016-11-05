#!/usr/bin/env bash
export LS_OPTIONS='-h --color -l --group-directories-first'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
alias ls="ls $LS_OPTIONS"

# Add colors for filetype, human-readable sizes and human-readable rights by default on 'ls':
alias l="ls $LS_OPTIONS -v | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias la="ls $LS_OPTIONS -v -A | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"

# Ls only for directory
alias ld="ls $LS_OPTIONS -d */ | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias lda="ls $LS_OPTIONS -ad */ | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"

# Ls only for files
alias lf="ls $LS_OPTIONS | egrep -v '^d' | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias lfa="ls $LS_OPTIONS -a | egrep -v '^d' | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
