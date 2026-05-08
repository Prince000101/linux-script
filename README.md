# Linux Script

A Chocolatey-like package manager and toolkit for Linux Mint (Ubuntu/Debian).  
Install software, manage your system, and run tools — all from the terminal.

---

## Installation

```bash
git clone https://github.com/Prince000101/linux-script
cd linux-script
bash install.sh
source ~/.bashrc
```

---

## Commands

### `lget` — Package Manager (Chocolatey-like)

| Command | What it does |
|---------|-------------|
| `lget install <pkg>` | Install one or more packages |
| `lget remove <pkg>` | Remove a package |
| `lget search <query>` | Search for packages |
| `lget search --all` | List every available package |
| `lget list` | Show which packages are installed |
| `lget info <pkg>` | Show package details |
| `lget update` | Full system update (apt + snap) |
| `lget -h` | Show help |

Install multiple packages at once:
```bash
lget install firefox vlc code discord steam
```

Search for packages:
```bash
lget search browser
lget search --all          # Everything available
```

Package info:
```bash
lget info git
```

### `ltool` — Toolkit

| Command | What it does |
|---------|-------------|
| `ltool` | Interactive menu |
| `ltool update` | System update & cleanup |
| `ltool info` | Show system information |
| `ltool dev` | Install development stack |
| `ltool media` | Install media tools |
| `ltool gaming` | Install gaming tools |
| `ltool -h` | Show help |

### `lhelp` — Help

```
lhelp     Show all commands and usage
```

---

## Quick Aliases

| Alias | Full command |
|-------|-------------|
| `lin firefox` | `lget install firefox` |
| `lrm firefox` | `lget remove firefox` |
| `lse browser` | `lget search browser` |
| `ll` | `lget list` |
| `li git` | `lget info git` |
| `lup` | `lget update` |

---

## Available Packages (70+)

| Category | Packages |
|----------|----------|
| **Browsers** | firefox, chrome, chromium, brave, edge |
| **Media** | vlc, mpv, gimp, inkscape, blender, obs, kdenlive, audacity, handbrake, shotcut, flameshot, spotify |
| **Communication** | discord, telegram, slack, zoom, whatsapp |
| **Development** | code, vscodium, sublime, neovim, git, nodejs, python3, docker, docker-compose, postman, mysql-workbench, jdk, rust, go, dotnet |
| **Utilities** | htop, neofetch, tmux, fish, zsh, bat, tree, ripgrep, curl, wget, tldr, btop, timeshift |
| **Gaming** | steam, lutris, heroic |
| **Security** | keepassxc, veracrypt |
| **Productivity** | libreoffice, obsidian, onlyoffice |
| **Tools** | ffmpeg, yt-dlp, aria2, virtualbox, qemu |

---

## How It Works

Behind the scenes:

- **apt** — Standard Debian/Ubuntu/Mint packages (most common)
- **snap** — Snap packages (blender, spotify, postman, etc.)
- **script** — Custom installers for packages that need special handling
- **pip / npm** — Python and Node.js packages

Each package is defined in a database inside the `lget` script with its name, description, category, and install method.

---

## Requirements

- Linux Mint (or Ubuntu/Debian-based distro)
- sudo access
- curl, wget (installed automatically)

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `sudo: command not found` | Install sudo: `apt install sudo` |
| Package not found | Run `lget search --all` to see available packages |
| Script-based install fails | The package may need updated URLs — open an issue |
| Completions not working | Run `source ~/.bashrc` or restart terminal |
| Aliases not working | Run `source ~/.bashrc` |

---

## Contact Developer

- **GitHub**: [Prince000101/linux-script](https://github.com/Prince000101/linux-script)
- **LinkedIn**: [Prince Kumar](https://www.linkedin.com/in/prince-kumar-41659823b)

---

## Credits

| Tool | Purpose |
|------|---------|
| [apt](https://wiki.debian.org/Apt) | Package management backend |
| [snap](https://snapcraft.io/) | Snap package support |
| [yt-dlp](https://github.com/yt-dlp/yt-dlp) | Video downloading |
| [ani-cli](https://github.com/pystardust/ani-cli) | Anime streaming |

---

*Built for simplicity. Inspired by Chocolatey for Windows.*
