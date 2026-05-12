#!/bin/bash

GREEN=$'\e[1;32m'; YELLOW=$'\e[1;33m'; RED=$'\e[1;31m'; CYAN=$'\e[1;36m'; NC=$'\e[0m'

echo -e "${CYAN}=========================================================${NC}"
echo -e "${GREEN}         Linux Script - Upgrade                          ${NC}"
echo -e "${CYAN}=========================================================${NC}"

ERRORS=0; UPDATED=(); STASHED=false

echo -e "\n${YELLOW}[1/6]${NC} Verifying environment..."
if ! command -v git &>/dev/null; then echo -e "${RED}  Install git first${NC}"; exit 1; fi
if [[ ! -d ".git" ]]; then echo -e "${RED}  Not a git repo${NC}"; exit 1; fi
if ! git remote -v | grep -q "origin"; then echo -e "${RED}  No remote origin${NC}"; exit 1; fi
echo -e "${GREEN}  OK${NC}"

echo -e "\n${YELLOW}[2/6]${NC} Checking local changes..."
if ! git diff --quiet || ! git diff --cached --quiet; then
  git stash push -m "upgrade auto-stash" 2>/dev/null; STASHED=true; echo -e "${GREEN}  Stashed${NC}"
else
  echo -e "${GREEN}  Clean${NC}"
fi

echo -e "\n${YELLOW}[3/6]${NC} Pulling latest code..."
PULL=$(git pull origin main 2>&1) || {
  echo -e "${RED}  Pull failed${NC}"; echo "$PULL"; ERRORS=1
}
echo "$PULL" | grep -qi "Already up" && echo -e "${GREEN}  Already up to date${NC}" || echo -e "${GREEN}  Pulled${NC}"

echo -e "\n${YELLOW}[4/6]${NC} Updating scripts..."
SCRIPT_DIR="./scripts"
BIN_DIR="/usr/local/bin"
DATA_DIR="/usr/local/share/linux-script"

sudo mkdir -p "$DATA_DIR"

for script in lget ltool lhelp; do
  local_path="$SCRIPT_DIR/$script"
  bin_path="$BIN_DIR/$script"
  [[ ! -f "$local_path" ]] && echo -e "${RED}  Missing $local_path${NC}" && continue

  local_hash=$(sha256sum "$local_path" | awk '{print $1}')
  bin_hash=$(sha256sum "$bin_path" 2>/dev/null | awk '{print $1}' || echo "")

  if [[ "$local_hash" != "$bin_hash" ]]; then
    sudo cp "$local_path" "$bin_path" && sudo chmod +x "$bin_path" && \
      echo -e "${GREEN}  $script updated${NC}" && UPDATED+=("$script")
  else
    echo -e "${GREEN}  $script up to date${NC}"
  fi
done

echo -e "\n${YELLOW}[5/6]${NC} Updating package database..."
for f in packages.sh packages.db; do
  if [[ -f "$SCRIPT_DIR/$f" ]]; then
    sudo cp "$SCRIPT_DIR/$f" "/usr/local/bin/$f"
    sudo mkdir -p "$DATA_DIR"
    sudo cp "$SCRIPT_DIR/$f" "$DATA_DIR/$f"
    echo -e "${GREEN}  $f${NC}"
  fi
done

echo -e "\n${YELLOW}[6/6]${NC} Updating completions..."
PKG_NAMES=$(grep -oP '^"[^|]+' scripts/packages.sh 2>/dev/null | sed 's/"//' | tr '\n' ' ')
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
echo -e "${GREEN}  Completions updated${NC}"

echo -e "\n${YELLOW}[6/6]${NC} Verifying dependencies..."
for dep in curl wget gpg sudo; do
  command -v "$dep" &>/dev/null || echo -e "${YELLOW}  Missing: $dep${NC}"
done
echo -e "${GREEN}  Done${NC}"

if $STASHED; then
  echo ""; echo -e "${YELLOW}Restoring local changes...${NC}"
  git stash pop 2>/dev/null && echo -e "${GREEN}  Restored${NC}" || echo -e "${RED}  Conflict${NC}"
fi

echo ""
echo -e "${CYAN}=========================================================${NC}"
if [[ $ERRORS -eq 0 && ${#UPDATED[@]} -eq 0 ]]; then
  echo -e "${GREEN}         Everything up to date!${NC}"
elif [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}         Upgrade Complete!${NC}"
else
  echo -e "${YELLOW}         Finished with warnings${NC}"
fi
echo -e "${CYAN}=========================================================${NC}"
[[ ${#UPDATED[@]} -gt 0 ]] && echo -e "\n${GREEN}Updated:${NC} ${UPDATED[*]}"
echo ""
