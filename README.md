# Linux Script

A Chocolatey-like package manager and system toolkit for **Linux Mint** (Ubuntu/Debian).  
Browse 150+ packages by category, select with arrow keys & Space — all from the terminal.

---

## Quick Start

```bash
git clone https://github.com/Prince000101/linux-script
cd linux-script
bash install.sh
source ~/.bashrc
lget
```

### Uninstall

```bash
cd linux-script
bash uninstall.sh
source ~/.bashrc
```

### Upgrade

```bash
cd linux-script
bash upgrade.sh
source ~/.bashrc
```

The upgrade script will:
1. Pull the latest code from GitHub
2. Compare checksums — only update scripts that actually changed
3. Update bash completions and aliases if needed
4. Verify all dependencies are installed
5. Restore any local changes you made

---

## `lget` — Interactive Package Manager

Run `lget` with no arguments to open the **interactive menu** (uses `whiptail` — arrow-key + mouse-click friendly):

```
  ┌───────── LGET — Linux Package Manager ─────────┐
  │                                                 │
  │  Browse packages by category:                   │
  │                                                 │
  │  Browsers        (8 packages)                   │
  │  Media & Graphics (20 packages)                 │
  │  Communication   (7 packages)                   │
  │  Development    (35 packages)                   │
  │  Utilities      (33 packages)                   │
  │  Gaming          (9 packages)                   │
  │  Security       (11 packages)                   │
  │  Productivity   (10 packages)                   │
  │  Tools           (6 packages)                   │
  │                                                 │
  │  SEARCH — Search all packages                   │
  │  INSTALLED — Show installed packages            │
  │  UPDATE — System update & cleanup               │
  │  HELP — Help & usage                            │
  │                                                 │
  │  ↑↓ navigate · ENTER select                     │
  └─────────────────────────────────────────────────┘
```

Select a category → use **↑↓ arrows** + **Space** to toggle packages, **Enter** to confirm:

```
  ┌─ LGET — Development (35 packages) ──────────────┐
  │                                                 │
  │  Select packages to install:                    │
  │  (already installed = pre-checked)              │
  │                                                 │
  │  ☐ git        Git version control               │
  │  ☑ code       Visual Studio Code editor         │
  │  ☐ nodejs     Node.js JavaScript runtime        │
  │  ☑ docker     Docker container platform         │
  │  ☐ python3    Python 3 + pip                    │
  │  ...                                           │
  │                                                 │
  │  ↑↓ navigate · Space toggle · ENTER confirm     │
  └─────────────────────────────────────────────────┘
```

Before installing, a confirmation screen shows every selected package with its description:

```
  ┌─ Confirm Installation ──────────────────────────┐
  │                                                 │
  │  You are about to install 3 package(s):         │
  │                                                 │
  │  1. git — Git version control                   │
  │  2. nodejs — Node.js JavaScript runtime         │
  │  3. docker — Docker container platform          │
  │                                                 │
  │  Proceed?              <Yes> <No>               │
  └─────────────────────────────────────────────────┘
```

During installation, each step shows detailed progress:

```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Installing: git
  Description: Git version control
  Category: Development
  Source: apt (git)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ↳ apt install -y git
    Reading package lists... Done
    Building dependency tree... Done
    ...
    ✓ Successfully installed: git
```

Falls back to a text-based number menu if `whiptail` is not installed.

### CLI Mode

For power users, `lget` also works as a command-line tool:

| Command | What it does |
|---------|-------------|
| `lget install firefox vlc code` | Install multiple packages |
| `lget remove <pkg>` | Remove a package |
| `lget search <query>` | Search packages |
| `lget search --all` | Show every package |
| `lget list` | Show installed packages |
| `lget info <pkg>` | Package details |
| `lget update` | System update |

### Quick Aliases

| Alias | Full command |
|-------|-------------|
| `lin firefox` | `lget install firefox` |
| `lrm firefox` | `lget remove firefox` |
| `lse browser` | `lget search browser` |
| `ll` | `lget list` |
| `li git` | `lget info git` |
| `lup` | `lget update` |

---

## `ltool` — System Toolkit

| Command | What it does |
|---------|-------------|
| `ltool` | Interactive menu |
| `ltool update` | System update & cleanup |
| `ltool info` | System info (CPU, RAM, disk, uptime) |
| `ltool dev` | Install dev stack (git, node, docker, vscode) |
| `ltool media` | Install media tools (ffmpeg, vlc, yt-dlp) |
| `ltool gaming` | Install gaming tools (steam, lutris) |

---

## Available Packages (150+)

| Category | Count | Packages |
|----------|-------|----------|
| **Browsers** | 8 | firefox, chrome, chromium, brave, edge, opera, vivaldi, tor-browser |
| **Media & Graphics** | 20 | vlc, mpv, gimp, inkscape, blender, obs, kdenlive, audacity, handbrake, shotcut, flameshot, krita, darktable, pitivi, rawtherapee, peek, simplescreenrecorder, losslesscut, mkvtoolnix, spotify |
| **Communication** | 7 | discord, telegram, slack, zoom, whatsapp, signal, element |
| **Development** | 35 | code, vscodium, sublime, neovim, git, nodejs, python3, docker, docker-compose, postman, mysql-workbench, mysql-server, postgresql, sqlite3, redis, php, composer, jdk, rust, go, dotnet, flutter, dart, kotlin, yarn, pnpm, gcc, make, cmake, android-studio, godot, vagrant, ansible, terraform, kubectl, aws-cli, gh, jupyter, elixir |
| **Utilities** | 33 | htop, btop, neofetch, tmux, fish, zsh, bat, tree, ripgrep, fd, procs, duf, dust, delta, hyperfine, tldr, cheat, jq, yq, fzf, ranger, nnn, mc, screen, rsync, sshfs, curl, wget, unzip, unrar, p7zip, glances, timeshift, fonts-firacode |
| **Gaming** | 9 | steam, lutris, heroic, wine, winetricks, playonlinux, gamemode, mangohud, minecraft |
| **Security** | 11 | keepassxc, veracrypt, bitwarden, nmap, wireshark, openssh, gpg, clamav, fail2ban, ufw, rkhunter |
| **Productivity** | 10 | libreoffice, onlyoffice, obsidian, thunderbird, calibre, anki, zotero, okular, goldendict, foxitreader |
| **Tools** | 6 | ffmpeg, yt-dlp, aria2, virtualbox, qemu, vagrant |

---

## Install Methods

| Method | Description | Example packages |
|--------|-------------|-----------------|
| **apt** | Native Debian packages | firefox, vlc, git, htop |
| **snap** | Snap packages | blender, spotify, postman |
| **script** | Custom install scripts | chrome, discord, docker, nodejs |
| **pip** | Python packages | yt-dlp, tldr, glances |
| **npm** | Node.js packages | pnpm |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `sudo: command not found` | `apt install sudo` |
| Package not found | `lget search --all` to see all packages |
| Script install fails | URLs may change — open a GitHub issue |
| Aliases not working | `source ~/.bashrc` |

---

## Contact Developer

- **GitHub**: [Prince000101/linux-script](https://github.com/Prince000101/linux-script)
- **LinkedIn**: [Prince Kumar](https://www.linkedin.com/in/prince-kumar-41659823b)

---

*Inspired by Chocolatey for Windows. Built for simplicity.*
