#!/bin/bash

CYAN='\033[1;36m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; BLUE='\033[1;34m'; NC='\033[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}         Linux Script - Upgrade                          ${NC}"
echo -e "${CYAN}=========================================================${NC}"
echo ""

ERRORS=0
UPDATED=()
STASHED=false

# ─── [1] Verify Environment ──────────────────────────────────────────────────

echo -e "${YELLOW}[1/6]${NC} Verifying environment..."

if ! command -v git &>/dev/null; then
  echo -e "${RED}  git is not installed. Install it: sudo apt install git${NC}"
  echo -e "${RED}  Then re-run this script.${NC}"
  exit 1
fi

if [ ! -d ".git" ]; then
  echo -e "${RED}  Not a git repository. Run this from inside the linux-script folder.${NC}"
  exit 1
fi

if ! git remote -v | grep -q "origin"; then
  echo -e "${RED}  No remote 'origin' configured. Cannot pull updates.${NC}"
  exit 1
fi

echo -e "${GREEN}  Environment OK${NC}"

# ─── [2] Stash local changes ─────────────────────────────────────────────────

echo -e "\n${YELLOW}[2/6]${NC} Checking for local changes..."

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo -e "${YELLOW}  Local changes detected. Stashing temporarily...${NC}"
  git stash push -m "upgrade.sh auto-stash" 2>/dev/null
  STASHED=true
  echo -e "${GREEN}  Stashed.${NC}"
else
  echo -e "${GREEN}  No local changes.${NC}"
fi

# ─── [3] Pull latest code ────────────────────────────────────────────────────

echo -e "\n${YELLOW}[3/6]${NC} Pulling latest code from GitHub..."

PULL_OUTPUT=$(git pull origin main 2>&1)
PULL_EXIT=$?

if [ $PULL_EXIT -ne 0 ]; then
  echo -e "${RED}  git pull failed.${NC}"
  if echo "$PULL_OUTPUT" | grep -qi "could not resolve\|Connection refused\|Network is unreachable\|timeout"; then
    echo -e "${YELLOW}  No internet connection. Working with local files only.${NC}"
  elif echo "$PULL_OUTPUT" | grep -qi "conflict"; then
    echo -e "${RED}  Merge conflict detected. Resolve manually, then re-run.${NC}"
    exit 1
  else
    echo -e "${RED}  $PULL_OUTPUT${NC}"
    ERRORS=1
  fi
elif echo "$PULL_OUTPUT" | grep -qi "Already up[ -]to[ -]date"; then
  echo -e "${GREEN}  Already on the latest version.${NC}"
  # Still check scripts are current in case they were manually deleted
else
  echo -e "${GREEN}  Pulled latest changes.${NC}"
fi

# ─── [4] Update scripts (checksum diff) ──────────────────────────────────────

echo -e "\n${YELLOW}[4/6]${NC} Updating scripts..."

SCRIPT_DIR="./scripts"
BIN_DIR="/usr/local/bin"
SCRIPTS="lget ltool lhelp"

for script in $SCRIPTS; do
  local_path="$SCRIPT_DIR/$script"
  bin_path="$BIN_DIR/$script"

  if [ ! -f "$local_path" ]; then
    echo -e "${RED}  $local_path not found in repo, skipping${NC}"
    continue
  fi

  if [ ! -f "$bin_path" ]; then
    echo -e "${YELLOW}  $script not installed. Installing...${NC}"
    if sudo cp "$local_path" "$bin_path" 2>/dev/null && sudo chmod +x "$bin_path"; then
      echo -e "${GREEN}  $script installed${NC}"
      UPDATED+=("$script")
    else
      echo -e "${RED}  Permission denied. Try: sudo cp $local_path $bin_path${NC}"
      ERRORS=1
    fi
    continue
  fi

  local_hash=$(sha256sum "$local_path" | awk '{print $1}')
  bin_hash=$(sha256sum "$bin_path" | awk '{print $1}')

  if [ "$local_hash" != "$bin_hash" ]; then
    echo -e "${YELLOW}  $script has updates. Copying...${NC}"
    if sudo cp "$local_path" "$bin_path" && sudo chmod +x "$bin_path"; then
      echo -e "${GREEN}  $script updated${NC}"
      UPDATED+=("$script")
    else
      echo -e "${RED}  Permission denied for $script${NC}"
      ERRORS=1
    fi
  else
    echo -e "${GREEN}  $script up to date${NC}"
  fi
done

# ─── [5] Update completions & aliases ────────────────────────────────────────

echo -e "\n${YELLOW}[5/6]${NC} Updating bash completions..."

COMP_FILE="/etc/bash_completion.d/lget"
# Build fresh completions inline
COMP_TMP=$(mktemp)
cat > "$COMP_TMP" <<'COMP'
_lget_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local commands="install remove search list info update help"
  local packages="firefox chrome chromium brave edge opera vivaldi tor-browser vlc mpv gimp inkscape blender obs kdenlive audacity handbrake shotcut flameshot krita darktable pitivi rawtherapee peek simplescreenrecorder losslesscut mkvtoolnix spotify discord telegram slack zoom whatsapp signal element code vscodium sublime neovim git nodejs python3 docker docker-compose postman mysql-workbench mysql-server postgresql sqlite3 redis php composer jdk rust go dotnet flutter dart kotlin yarn pnpm gcc make cmake android-studio godot vagrant ansible terraform kubectl aws-cli gh jupyter elixir htop btop neofetch tmux fish zsh bat tree ripgrep fd procs duf dust delta hyperfine tldr cheat jq yq fzf ranger nnn mc screen rsync sshfs curl wget unzip unrar p7zip glances timeshift fonts-firacode steam lutris heroic wine winetricks playonlinux gamemode mangohud minecraft keepassxc veracrypt bitwarden nmap wireshark openssh gpg clamav fail2ban ufw rkhunter libreoffice onlyoffice obsidian thunderbird calibre anki zotero okular goldendict foxitreader ffmpeg yt-dlp aria2 virtualbox qemu"
  case $prev in
    install|remove|info)
      COMPREPLY=($(compgen -W "$packages" -- "$cur")) ;;
    *) COMPREPLY=($(compgen -W "$commands" -- "$cur")) ;;
  esac
}
complete -F _lget_completions lget
COMP

UPDATE_COMP=false
if [ -f "$COMP_FILE" ]; then
  if ! cmp -s "$COMP_TMP" "$COMP_FILE"; then
    UPDATE_COMP=true
  fi
else
  UPDATE_COMP=true
fi

if $UPDATE_COMP; then
  if sudo cp "$COMP_TMP" "$COMP_FILE" 2>/dev/null; then
    echo -e "${GREEN}  Completions updated${NC}"
  else
    echo -e "${RED}  Permission denied for completions${NC}"
    ERRORS=1
  fi
else
  echo -e "${GREEN}  Completions up to date${NC}"
fi
rm -f "$COMP_TMP"

echo -e "\n${YELLOW}[5/6]${NC} Checking aliases..."

BASHRC="$HOME/.bashrc"
ALIAS_MARKER="# Linux Script Aliases"
UPDATE_ALIASES=false

if [ -f "$BASHRC" ] && grep -q "$ALIAS_MARKER" "$BASHRC"; then
  echo -e "${GREEN}  Aliases already present${NC}"
else
  UPDATE_ALIASES=true
fi

if $UPDATE_ALIASES; then
  sed -i '/# Linux Script Aliases/,/^$/d' "$BASHRC" 2>/dev/null
  sed -i '/alias lin=/d' "$BASHRC" 2>/dev/null
  sed -i '/alias lrm=/d' "$BASHRC" 2>/dev/null
  sed -i '/alias lse=/d' "$BASHRC" 2>/dev/null
  sed -i '/alias ll=/d' "$BASHRC" 2>/dev/null
  sed -i '/alias li=/d' "$BASHRC" 2>/dev/null
  sed -i '/alias lup=/d' "$BASHRC" 2>/dev/null

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
fi

# ─── [5/6] Verify Dependencies ──────────────────────────────────────────────

echo -e "\n${YELLOW}[6/6]${NC} Verifying dependencies..."
DEPS="curl wget gpg sudo"
MISSING=()
for dep in $DEPS; do
  if ! command -v "$dep" &>/dev/null; then
    MISSING+=("$dep")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo -e "${YELLOW}  Missing tools: ${MISSING[*]}${NC}"
  echo -e "${YELLOW}  Some installers may not work. Install with: sudo apt install ${MISSING[*]}${NC}"
else
  echo -e "${GREEN}  All required tools present${NC}"
fi

# ─── Re-apply stash ─────────────────────────────────────────────────────────

if $STASHED; then
  echo ""
  echo -e "${YELLOW}Re-applying local changes...${NC}"
  if git stash pop 2>/dev/null; then
    echo -e "${GREEN}  Local changes restored.${NC}"
  else
    echo -e "${RED}  Merge conflict when restoring local changes.${NC}"
    echo -e "${YELLOW}  Resolve manually with: git stash pop${NC}"
    ERRORS=1
  fi
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}=========================================================${NC}"

if [ $ERRORS -eq 0 ] && [ ${#UPDATED[@]} -eq 0 ]; then
  echo -e "${GREEN}            Everything is up to date!${NC}"
elif [ $ERRORS -eq 0 ] && [ ${#UPDATED[@]} -gt 0 ]; then
  echo -e "${GREEN}            Upgrade Complete!                           ${NC}"
else
  echo -e "${YELLOW}            Upgrade finished with warnings              ${NC}"
fi

echo -e "${CYAN}=========================================================${NC}"
echo ""

if [ ${#UPDATED[@]} -gt 0 ]; then
  echo -e "${GREEN}  Updated:${NC} ${UPDATED[*]}"
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  echo -e "${YELLOW}  Missing deps:${NC} ${MISSING[*]}"
  echo -e "${YELLOW}  Install: sudo apt install ${MISSING[*]}${NC}"
fi

echo ""
echo -e "${GREEN}Run 'lget' to start using the latest version.${NC}"
