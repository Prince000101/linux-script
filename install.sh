#!/bin/bash

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}         Linux Script - Complete Installation             ${NC}"
echo -e "${CYAN}=========================================================${NC}"

# Check if running on Linux
if [ "$(uname)" != "Linux" ]; then
  echo -e "${RED}This installer is for Linux only.${NC}"
  exit 1
fi

# Check sudo
if ! command -v sudo &>/dev/null; then
  echo -e "${RED}sudo is required. Install it first.${NC}"
  exit 1
fi

# ─── Install ──────────────────────────────────────────────────────────────────

echo -e "\n${YELLOW}[1/4]${NC} Installing system dependencies..."
sudo apt update -qq
sudo apt install -y curl wget gpg 2>&1 | tail -1

echo -e "\n${YELLOW}[2/4]${NC} Installing toolkit scripts..."
SCRIPT_DIR="./scripts"
SCRIPTS="lget ltool lhelp"

for script in $SCRIPTS; do
  if [ -f "$SCRIPT_DIR/$script" ]; then
    sudo cp "$SCRIPT_DIR/$script" "/usr/local/bin/$script"
    sudo chmod +x "/usr/local/bin/$script"
    echo -e "${GREEN}  $script installed to /usr/local/bin/${NC}"
  else
    echo -e "${RED}  $SCRIPT_DIR/$script not found, skipping${NC}"
  fi
done

echo -e "\n${YELLOW}[3/4]${NC} Setting up bash aliases..."
BASHRC="$HOME/.bashrc"
touch "$BASHRC"

# Remove old linux-script aliases block
sed -i '/# Linux Script Aliases/,/^$/d' "$BASHRC"
sed -i '/alias lin/d' "$BASHRC"

cat <<'EOF' >> "$BASHRC"

# Linux Script Aliases
alias lin='lget install'
alias lrm='lget remove'
alias lse='lget search'
alias ll='lget list'
alias li='lget info'
alias lup='lget update'
EOF

echo -e "${GREEN}  Aliases added to ~/.bashrc${NC}"

echo -e "\n${YELLOW}[4/4]${NC} Installing bash completions for lget..."
sudo tee /etc/bash_completion.d/lget >/dev/null <<'COMPLETIONS'
_lget_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local commands="install remove search list info update help"
  case $prev in
    install|remove|info)
      COMPREPLY=($(compgen -W "firefox chrome chromium brave edge vlc mpv gimp inkscape blender obs kdenlive audacity handbrake shotcut flameshot spotify discord telegram slack zoom whatsapp code vscodium sublime neovim git nodejs python3 docker docker-compose postman mysql-workbench jdk rust go dotnet htop neofetch tmux fish zsh bat tree ripgrep curl wget tldr btop timeshift steam lutris heroic keepassxc veracrypt libreoffice obsidian onlyoffice ffmpeg yt-dlp aria2 virtualbox qemu" -- "$cur"))
      ;;
    *)
      COMPREPLY=($(compgen -W "$commands" -- "$cur"))
      ;;
  esac
}
complete -F _lget_completions lget
COMPLETIONS

echo -e "${GREEN}  Bash completions installed${NC}"

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}            Installation Complete!                       ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""
echo -e "${YELLOW}Available Commands:${NC}"
echo ""
echo -e "  ${GREEN}lget${NC}         Package manager (Chocolatey-like)"
echo -e "  ${GREEN}ltool${NC}        Interactive Linux toolkit"
echo -e "  ${GREEN}lhelp${NC}        Show help overview"
echo ""
echo -e "${YELLOW}Quick Aliases:${NC}"
echo -e "  ${GREEN}lin${NC} <pkg>     Alias for lget install"
echo -e "  ${GREEN}lrm${NC} <pkg>     Alias for lget remove"
echo -e "  ${GREEN}lse${NC} <query>   Alias for lget search"
echo -e "  ${GREEN}ll${NC}            Alias for lget list"
echo -e "  ${GREEN}li${NC} <pkg>      Alias for lget info"
echo -e "  ${GREEN}lup${NC}           Alias for lget update"
echo ""
echo -e "${YELLOW}Examples:${NC}"
echo -e "  ${GREEN}lget install firefox vlc code${NC}"
echo -e "  ${GREEN}lin discord steam${NC}"
echo -e "  ${GREEN}lget search --all${NC}"
echo -e "  ${GREEN}ltool menu${NC}"
echo ""
echo -e "${YELLOW}Run 'source ~/.bashrc' to activate aliases now.${NC}"
echo ""
echo -e "${GREEN}Enjoy!${NC}"
