#!/bin/bash

GREEN=$'\e[1;32m'; YELLOW=$'\e[1;33m'; RED=$'\e[1;31m'; CYAN=$'\e[1;36m'; NC=$'\e[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}         Linux Script - Complete Installation             ${NC}"
echo -e "${CYAN}=========================================================${NC}"

if [[ "$(uname)" != "Linux" ]]; then
  echo -e "${RED}Linux only.${NC}"; exit 1
fi
if ! command -v sudo &>/dev/null; then
  echo -e "${RED}sudo is required.${NC}"; exit 1
fi

echo -e "\n${YELLOW}[1/5]${NC} Installing system dependencies..."
sudo apt update -qq
sudo apt install -y curl wget gpg 2>&1 | tail -1

echo -e "\n${YELLOW}[2/5]${NC} Installing toolkit scripts..."
SCRIPT_DIR="./scripts"
DATA_DIR="/usr/local/share/linux-script"
sudo mkdir -p "$DATA_DIR"

for script in lget ltool lhelp; do
  if [[ -f "$SCRIPT_DIR/$script" ]]; then
    sudo cp "$SCRIPT_DIR/$script" "/usr/local/bin/$script"
    sudo chmod +x "/usr/local/bin/$script"
    echo -e "${GREEN}  $script${NC}"
  fi
done

echo -e "${YELLOW}  Installing package database...${NC}"
if [[ -f "$SCRIPT_DIR/packages.sh" ]]; then
  sudo cp "$SCRIPT_DIR/packages.sh" "$DATA_DIR/packages.sh"
  echo -e "${GREEN}  packages.sh${NC}"
fi
if [[ -f "packages.db" ]]; then
  sudo cp "packages.db" "$DATA_DIR/packages.db"
  echo -e "${GREEN}  packages.db${NC}"
fi

echo -e "\n${YELLOW}[3/5]${NC} Setting up bash aliases..."
BASHRC="$HOME/.bashrc"; touch "$BASHRC"
sed -i '/# Linux Script Aliases/,/^$/d' "$BASHRC"
sed -i '/alias lin=/d' "$BASHRC"; sed -i '/alias lrm=/d' "$BASHRC"
sed -i '/alias lse=/d' "$BASHRC"; sed -i '/alias ll=/d' "$BASHRC"
sed -i '/alias li=/d' "$BASHRC"; sed -i '/alias lup=/d' "$BASHRC"
cat <<'EOF' >> "$BASHRC"

# Linux Script Aliases
alias lin='lget install'
alias lrm='lget remove'
alias lse='lget search'
alias ll='lget list'
alias li='lget info'
alias lup='lget update'
EOF
echo -e "${GREEN}  Aliases added${NC}"

echo -e "\n${YELLOW}[4/5]${NC} Installing bash completions..."
PKG_NAMES=$(grep -oP '^"[^|]+' scripts/packages.sh | sed 's/"//' | tr '\n' ' ')
sudo tee /etc/bash_completion.d/lget >/dev/null <<COMPLETIONS
_lget_completions() {
  local cur="\${COMP_WORDS[COMP_CWORD]}"
  local prev="\${COMP_WORDS[COMP_CWORD-1]}"
  local commands="install remove search list info update upgrade help"
  local packages="$PKG_NAMES"
  case \$prev in
    install|remove|info)
      COMPREPLY=(\$(compgen -W "\$packages" -- "\$cur")) ;;
    *) COMPREPLY=(\$(compgen -W "\$commands" -- "\$cur")) ;;
  esac
}
complete -F _lget_completions lget
COMPLETIONS
echo -e "${GREEN}  Completions installed${NC}"

echo -e "\n${YELLOW}[5/5]${NC} Verifying installation..."
for cmd in lget ltool lhelp; do
  if command -v "$cmd" &>/dev/null; then
    echo -e "${GREEN}  ✓ $cmd${NC}"
  else
    echo -e "${RED}  ✗ $cmd${NC}"
  fi
done

echo ""
echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}            Installation Complete!                       ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""
echo -e "${YELLOW}Commands:${NC}"
echo -e "  ${GREEN}lget install <pkg>${NC}  Install packages"
echo -e "  ${GREEN}lget search --all${NC}   Browse all packages"
echo -e "  ${GREEN}lget list${NC}           Show installed"
echo -e "  ${GREEN}ltool info${NC}          System info"
echo ""
echo -e "Run ${GREEN}source ~/.bashrc${NC} to activate aliases."
