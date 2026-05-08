#!/bin/bash

CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}         Linux Script - Complete Installation             ${NC}"
echo -e "${CYAN}=========================================================${NC}"

if [ "$(uname)" != "Linux" ]; then
  echo -e "${RED}This installer is for Linux only.${NC}"; exit 1
fi
if ! command -v sudo &>/dev/null; then
  echo -e "${RED}sudo is required. Install it first.${NC}"; exit 1
fi

echo -e "\n${YELLOW}[1/4]${NC} Installing system dependencies..."
sudo apt update -qq
sudo apt install -y curl wget gpg 2>&1 | tail -1

echo -e "\n${YELLOW}[2/4]${NC} Installing toolkit scripts..."
SCRIPT_DIR="./scripts"
for script in lget ltool lhelp; do
  if [ -f "$SCRIPT_DIR/$script" ]; then
    sudo cp "$SCRIPT_DIR/$script" "/usr/local/bin/$script"
    sudo chmod +x "/usr/local/bin/$script"
    echo -e "${GREEN}  $script installed to /usr/local/bin/${NC}"
  else
    echo -e "${RED}  $SCRIPT_DIR/$script not found, skipping${NC}"
  fi
done

echo -e "\n${YELLOW}[3/4]${NC} Setting up bash aliases..."
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
echo -e "${GREEN}  Aliases added to ~/.bashrc${NC}"

echo -e "\n${YELLOW}[4/4]${NC} Installing bash completions..."
sudo tee /etc/bash_completion.d/lget >/dev/null <<'COMPLETIONS'
_lget_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local commands="install remove search list info update help"
  case $prev in
    install|remove|info)
      COMPREPLY=($(compgen -W "firefox chrome chromium brave edge opera vivaldi tor-browser vlc mpv gimp inkscape blender obs kdenlive audacity handbrake shotcut flameshot krita darktable pitivi rawtherapee peek simplescreenrecorder losslesscut mkvtoolnix spotify discord telegram slack zoom whatsapp signal element code vscodium sublime neovim git nodejs python3 docker docker-compose postman mysql-workbench mysql-server postgresql sqlite3 redis php composer jdk rust go dotnet flutter dart kotlin yarn pnpm gcc make cmake android-studio godot vagrant ansible terraform kubectl aws-cli gh jupyter elixir htop btop neofetch tmux fish zsh bat tree ripgrep fd procs duf dust delta hyperfine tldr cheat jq yq fzf ranger nnn mc screen rsync sshfs curl wget unzip unrar p7zip glances timeshift fonts-firacode steam lutris heroic wine winetricks playonlinux gamemode mangohud minecraft keepassxc veracrypt bitwarden nmap wireshark openssh gpg clamav fail2ban ufw rkhunter libreoffice onlyoffice obsidian thunderbird calibre anki zotero okular goldendict foxitreader ffmpeg yt-dlp aria2 virtualbox qemu" -- "$cur"))
      ;;
    *) COMPREPLY=($(compgen -W "$commands" -- "$cur")) ;;
  esac
}
complete -F _lget_completions lget
COMPLETIONS
echo -e "${GREEN}  Bash completions installed${NC}"

echo ""
echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}            Installation Complete!                       ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""
echo -e "${YELLOW}Commands:${NC}"
echo -e "  ${GREEN}lget${NC}         Interactive package manager (just type lget)"
echo -e "  ${GREEN}ltool${NC}        System toolkit menu"
echo -e "  ${GREEN}lhelp${NC}        Show help overview"
echo ""
echo -e "${YELLOW}Try it now:${NC}"
echo -e "  ${GREEN}lget${NC}          -> Browse categories and install packages"
echo -e "  ${GREEN}lin${NC} firefox   -> Install Firefox via alias"
echo -e "  ${GREEN}lup${NC}           -> System update"
echo ""
echo -e "${YELLOW}Run 'source ~/.bashrc' to activate aliases.${NC}"
echo -e "${GREEN}Enjoy!${NC}"
