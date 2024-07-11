#!/usr/bin/env bash

PATH=$PATH:/usr/local
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/sbin
PATH=$PATH:/usr/bin
PATH=$PATH:/sbin
PATH=$PATH:/bin
PATH=$PATH:/usr/games
PATH=$PATH:/usr/local/cuda-8.0/bin
PATH=$PATH:$HOME/.cargo/env
PATH=$PATH:/home/john/.local/share/JetBrains/Toolbox/scripts

# Remove duplicates
CLEAN_PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

# Update PATH variable
if [ "$CLEAN_PATH" != "" ]; then
  export PATH=$CLEAN_PATH
else
  export PATH
fi

# Export CUDA library path
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
