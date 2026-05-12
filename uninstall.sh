#!/bin/bash

GREEN=$'\e[1;32m'; YELLOW=$'\e[1;33m'; RED=$'\e[1;31m'; CYAN=$'\e[1;36m'; NC=$'\e[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${RED}         Linux Script - Uninstall                         ${NC}"
echo -e "${CYAN}=========================================================${NC}"

if [[ "$(uname)" != "Linux" ]]; then
  echo -e "${RED}Linux only.${NC}"; exit 1
fi

echo -e "\n${YELLOW}[1/4]${NC} Removing scripts..."
for script in lget ltool lhelp lget-tui; do
  if [[ -f "/usr/local/bin/$script" ]]; then
    sudo rm "/usr/local/bin/$script"
    echo -e "${GREEN}  Removed /usr/local/bin/$script${NC}"
  fi
done

echo -e "\n${YELLOW}[2/4]${NC} Removing package database..."
for f in packages.sh packages.db; do
  if [[ -f "/usr/local/bin/$f" ]]; then
    sudo rm "/usr/local/bin/$f"
    echo -e "${GREEN}  Removed /usr/local/bin/$f${NC}"
  fi
done
DATA_DIR="/usr/local/share/linux-script"
if [[ -d "$DATA_DIR" ]]; then
  sudo rm -rf "$DATA_DIR"
  echo -e "${GREEN}  Removed $DATA_DIR${NC}"
fi

echo -e "\n${YELLOW}[3/4]${NC} Removing bash completions..."
if [[ -f "/etc/bash_completion.d/lget" ]]; then
  sudo rm "/etc/bash_completion.d/lget"
  echo -e "${GREEN}  Removed completions${NC}"
fi

echo -e "\n${YELLOW}[4/4]${NC} Removing aliases from ~/.bashrc..."
BASHRC="$HOME/.bashrc"
if [[ -f "$BASHRC" ]]; then
  sed -i '/# Linux Script Aliases/,/^$/d' "$BASHRC"
  sed -i '/alias lin=/d' "$BASHRC"; sed -i '/alias lrm=/d' "$BASHRC"
  sed -i '/alias lse=/d' "$BASHRC"; sed -i '/alias ll=/d' "$BASHRC"
  sed -i '/alias li=/d' "$BASHRC"; sed -i '/alias lup=/d' "$BASHRC"
  echo -e "${GREEN}  Aliases removed${NC}"
  echo -e "${YELLOW}  Run 'source ~/.bashrc' to apply.${NC}"
fi

echo ""
echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}            Uninstall Complete!                         ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} Packages you installed are NOT removed."
echo "To remove them: lget remove <package>"
