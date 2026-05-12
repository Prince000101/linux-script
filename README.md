# Linux Script

A Chocolatey-like package manager and system toolkit for **Linux** (Ubuntu/Debian).  
Install, search, and manage 150+ packages straight from the terminal.

---

## Quick Start

```bash
git clone https://github.com/Prince000101/linux-script
cd linux-script
bash install.sh
source ~/.bashrc
lget install firefox vlc code
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
```

The upgrade script will:
1. Pull the latest code from GitHub
2. Install system dependencies (curl, wget, gpg) and compile the TUI package browser
3. Update scripts and package database
4. Add bash aliases and completions

---

## `lget` — Package Manager

CLI-first, fast, and scriptable. Just type commands:

| Command | What it does |
|---------|-------------|
| `lget` | Interactive TUI package browser (arrow keys, Space to select, Enter to confirm) |
| `lget install firefox vlc code` | Install multiple packages |
| `lget remove <pkg>` | Remove a package |
| `lget search <query>` | Search packages |
| `lget search --all` | List every package |
| `lget list` | Show installed packages |
| `lget info <pkg>` | Package details |
| `lget update` | System update |
| `lget upgrade` | Alias for update |

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

System maintenance commands:

| Command | What it does |
|---------|-------------|
| `ltool update` | System update & cleanup |
| `ltool info` | System info (CPU, RAM, disk, uptime, network) |
| `ltool dev` | Install dev stack (calls `lget install`) |
| `ltool media` | Install media tools (calls `lget install`) |
| `ltool gaming` | Install gaming tools (calls `lget install`) |
| `ltool clean` | Deep cleanup (temp, journal, snap, apt cache) |

---

## `lhelp` — Help

```
lhelp              Show all help sections
lhelp lget         Package manager help only
lhelp ltool        System toolkit help only
lhelp examples     Usage examples
```

---

## Available Packages (150+)

| Category | Count | Packages |
|----------|-------|----------|
| **Browsers** | 8 | firefox, chrome, chromium, brave, edge, opera, vivaldi, tor-browser |
| **Media & Graphics** | 20 | vlc, mpv, gimp, inkscape, blender, obs, kdenlive, audacity, handbrake, shotcut, flameshot, krita, darktable, pitivi, rawtherapee, peek, simplescreenrecorder, losslesscut, mkvtoolnix, spotify |
| **Communication** | 7 | discord, telegram, slack, zoom, whatsapp, signal, element |
| **Development** | 33 | code, vscodium, sublime, neovim, git, nodejs, python3, docker, docker-compose, postman, mysql-workbench, mysql-server, postgresql, sqlite3, redis, php, composer, jdk, rust, go, dotnet, flutter, dart, kotlin, yarn, pnpm, gcc, make, cmake, android-studio, godot, vagrant, ansible, terraform, kubectl, jupyter, elixir |
| **Utilities** | 33 | htop, btop, neofetch, tmux, fish, zsh, bat, tree, ripgrep, fd, procs, duf, dust, delta, hyperfine, tldr, cheat, jq, yq, fzf, ranger, nnn, mc, screen, rsync, sshfs, curl, wget, unzip, unrar, p7zip, glances, timeshift, fonts-firacode |
| **Gaming** | 9 | steam, lutris, heroic, wine, winetricks, playonlinux, gamemode, mangohud, minecraft |
| **Security** | 11 | keepassxc, veracrypt, bitwarden, nmap, wireshark, openssh, gpg, clamav, fail2ban, ufw, rkhunter |
| **Productivity** | 10 | libreoffice, onlyoffice, obsidian, thunderbird, calibre, anki, zotero, okular, goldendict, foxitreader |
| **Tools** | 19 | ffmpeg, yt-dlp, aria2, virtualbox, qemu, minikube, helm, lazygit, lazydocker, httpie, wget2, shellcheck, shfmt, bpython, entr, ctop, asciinema, aws-cli, gh |

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

## Contact

- **GitHub**: [Prince000101/linux-script](https://github.com/Prince000101/linux-script)
- **LinkedIn**: [Prince Kumar](https://www.linkedin.com/in/prince-kumar-41659823b)

---

*Inspired by Chocolatey for Windows. Built for simplicity.*
