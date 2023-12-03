#!/usr/bin/env bash

export AWE_INSTALL_FOLDER="$( command cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Loading resources
source "$AWE_INSTALL_FOLDER/core/config/Color.sh"

# allowed colors for prompt
COLORS=("$BRed" "$BOrange" "$BGreen" "$BYellow" "$BBlue" "$BPurple" "$BCyan" "$BWhite")

echo -e "\n${BYellow}#######################${NC}"
echo -e "${BYellow}#${NC}   ${BGreen}Ultimate BashRc${NC}   ${BYellow}#${NC}"
echo -e "${BYellow}#${NC} ${BOrange}Prompt Configurator${NC} ${BYellow}#${NC}"
echo -e "${BYellow}#######################${NC}\n"

MACHINE=$(hostname)

# PS1 main color selection
index=0
for color in "${COLORS[@]}"
do
  CLEAN_PROMPT="${color}┌─${NC}[14:50:37] ${color}$USER${NC}@$MACHINE (~/Git/AweBashrc) [master *+ u=] ${color}──┤${NC}\n"
  CLEAN_PROMPT+="${color}└┤${NC}\$${color}├─►${NC} "

  index=$((index+1))
  echo -e "$CLEAN_PROMPT ($index)"
done

# ask for user input
echo -e "\n${BOrange}Please select your favorite color for the main prompt:${NC}"
PS1_MAIN_COLOR=""
select color in "${COLORS[@]}"
do
  PS1_MAIN_COLOR="$color"
  break
done

# PS1 path color selection
index=0
for color in "${COLORS[@]}"
do
  CLEAN_PROMPT="${PS1_MAIN_COLOR}┌─${NC}[14:50:37] ${PS1_MAIN_COLOR}$USER${NC}@$MACHINE (${color}~/Git/AweBashrc${NC}) [master *+ u=] ${PS1_MAIN_COLOR}──┤${NC}\n"
  CLEAN_PROMPT+="${PS1_MAIN_COLOR}└┤${NC}\$${PS1_MAIN_COLOR}├─►${NC} "

  index=$((index+1))
  echo -e "$CLEAN_PROMPT ($index)"
done

# ask for user input
echo -e "\n${BOrange}Please select your favorite color for the path:${NC}"
PS1_PATH_COLOR=""
select color in "${COLORS[@]}"
do
  PS1_PATH_COLOR="$color"
  break
done

# PS1 git color selection
index=0
for color in "${COLORS[@]}"
do
  CLEAN_PROMPT="${PS1_MAIN_COLOR}┌─${NC}[14:50:37] ${PS1_MAIN_COLOR}$USER${NC}@$MACHINE (${PS1_PATH_COLOR}~/Git/AweBashrc${NC}) [${color}master *+ u=${NC}] ${PS1_MAIN_COLOR}──┤${NC}\n"
  CLEAN_PROMPT+="${PS1_MAIN_COLOR}└┤${NC}\$${PS1_MAIN_COLOR}├─►${NC} "

  index=$((index+1))
  echo -e "$CLEAN_PROMPT ($index)"
done

# ask for user input
echo -e "\n${BOrange}Please select your favorite color for the git status:${NC}"
PS1_GIT_COLOR=""
select color in "${COLORS[@]}"
do
  PS1_GIT_COLOR="$color"
  break
done

# write selection to cache/prompt.color
echo "PS1_MAIN=\"${PS1_MAIN_COLOR}\"" > "$AWE_INSTALL_FOLDER/cache/prompt.color"
echo "PS1_PATH=\"${PS1_PATH_COLOR}\"" >> "$AWE_INSTALL_FOLDER/cache/prompt.color"
echo "PS1_GIT=\"${PS1_GIT_COLOR}\"" >> "$AWE_INSTALL_FOLDER/cache/prompt.color"

echo -e "\n${BGreen}Prompt configuration saved${NC}.\n"
echo -e "Please ${BOrange}restart your terminal${NC} or run ${BOrange}source${NC} to apply changes.\n"
