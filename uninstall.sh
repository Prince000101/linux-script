#!/bin/bash

CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${RED}         Linux Script - Uninstall                         ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""

if [ "$(uname)" != "Linux" ]; then
  echo -e "${RED}This uninstaller is for Linux only.${NC}"; exit 1
fi

# Remove scripts
echo -e "${YELLOW}[1/3]${NC} Removing scripts..."
for script in lget ltool lhelp; do
  if [ -f "/usr/local/bin/$script" ]; then
    sudo rm "/usr/local/bin/$script"
    echo -e "${GREEN}  Removed /usr/local/bin/$script${NC}"
  else
    echo "  /usr/local/bin/$script not found, skipping"
  fi
done

# Remove bash completions
echo -e "\n${YELLOW}[2/3]${NC} Removing bash completions..."
if [ -f "/etc/bash_completion.d/lget" ]; then
  sudo rm "/etc/bash_completion.d/lget"
  echo -e "${GREEN}  Removed /etc/bash_completion.d/lget${NC}"
else
  echo "  Completions not found, skipping"
fi

# Remove aliases from ~/.bashrc
echo -e "\n${YELLOW}[3/3]${NC} Removing aliases from ~/.bashrc..."
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
  sed -i '/# Linux Script Aliases/,/^$/d' "$BASHRC"
  sed -i '/alias lin=/d' "$BASHRC"
  sed -i '/alias lrm=/d' "$BASHRC"
  sed -i '/alias lse=/d' "$BASHRC"
  sed -i '/alias ll=/d' "$BASHRC"
  sed -i '/alias li=/d' "$BASHRC"
  sed -i '/alias lup=/d' "$BASHRC"
  echo -e "${GREEN}  Aliases removed from ~/.bashrc${NC}"
  echo -e "${YELLOW}  Run 'source ~/.bashrc' to apply changes.${NC}"
else
  echo "  ~/.bashrc not found, skipping"
fi

echo ""
echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}            Uninstall Complete!                         ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""
echo -e "${YELLOW}The following have been removed:${NC}"
echo "  - lget, ltool, lhelp commands"
echo "  - Bash completions for lget"
echo "  - Aliases (lin, lrm, lse, ll, li, lup)"
echo ""
echo -e "${YELLOW}Note:${NC} This does NOT uninstall any packages you installed"
echo "via lget. To remove those, use: lget remove <package>"
echo ""
