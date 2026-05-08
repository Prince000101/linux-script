# Linux Script

A Chocolatey-like package manager and system toolkit for **Linux Mint** (Ubuntu/Debian).  
Browse 150+ packages by category, install with a number picker — all from the terminal.

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

---

## `lget` — Interactive Package Manager

Run `lget` with no arguments to open the **interactive menu**:

```
┌─────────────────────────────────────────────────────┐
│            LGET - Linux Package Manager              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Browse packages by category:                       │
│                                                     │
│  [1] Browsers                (8 packages)           │
│  [2] Media & Graphics       (20 packages)           │
│  [3] Communication           (7 packages)           │
│  [4] Development            (35 packages)           │
│  [5] Utilities              (33 packages)           │
│  [6] Gaming                  (9 packages)           │
│  [7] Security               (11 packages)           │
│  [8] Productivity           (10 packages)           │
│  [9] Tools                   (6 packages)           │
│                                                     │
│  [s] Search all packages                            │
│  [i] Show installed packages                        │
│  [u] System update & cleanup                        │
│  [q] Quit                                           │
│                                                     │
│  Choice: _                                          │
└─────────────────────────────────────────────────────┘
```

Select a category → see all packages → enter numbers to install:

```
  Category: Development                  [35 packages]

  [1] git          Git version control      [2] code         VS Code editor
  [3] nodejs       Node.js runtime          [4] docker       Docker platform
  [5] python3      Python 3 + pip           [6] neovim       Modern Vim
  ...

  Enter numbers to install (e.g. 1 3 5-8)
  [b] Back    [q] Quit

  Choice: 1 3 4
```

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
