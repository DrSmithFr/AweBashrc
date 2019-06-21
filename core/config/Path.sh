#!/usr/bin/env bash

PATH=$PATH:/usr/local:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/cuda-8.0/bin:$HOME/.cargo/env

# remove duplicate path entries
export PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
