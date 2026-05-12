package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type pkg struct {
	name, desc, cat, src string
}

var (
	titleStyle   = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("42"))
	subtitleStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("45"))
	catStyle     = lipgloss.NewStyle().Padding(0, 1)
	catSelStyle  = lipgloss.NewStyle().Padding(0, 1).Foreground(lipgloss.Color("0")).Background(lipgloss.Color("42"))
	pkgStyle     = lipgloss.NewStyle().Padding(0, 1)
	pkgSelStyle  = lipgloss.NewStyle().Padding(0, 1).Foreground(lipgloss.Color("0")).Background(lipgloss.Color("45"))
	checkStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))
	uncheckStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	helpStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	headerStyle  = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("45"))
	confirmStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))
	countStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("42")).Bold(true)
)

type model struct {
	pkgs      []pkg
	cats      []string
	catPkgs   map[string][]pkg
	state     int // 0=categories, 1=packages, 2=confirm
	catCur    int
	pkgCur    int
	selected  map[string]bool
	width     int
	height    int
}

func readPkgs(path string) ([]pkg, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var pkgs []pkg
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		if line == "" || strings.HasPrefix(line, "#") || strings.HasPrefix(line, "PKGS") || strings.HasPrefix(line, ")") {
			continue
		}
		line = strings.Trim(line, "\"")
		parts := strings.SplitN(line, "|", 4)
		if len(parts) == 4 {
			pkgs = append(pkgs, pkg{name: parts[0], desc: parts[1], cat: parts[2], src: parts[3]})
		}
	}
	return pkgs, sc.Err()
}

func findDB() string {
	exe, _ := os.Executable()
	dirs := []string{
		filepath.Dir(exe),
		"/usr/local/share/linux-script",
		"/usr/local/bin",
		".",
		"..",
	}
	for _, d := range dirs {
		for _, name := range []string{"packages.db", "packages.sh"} {
			p := filepath.Join(d, name)
			if _, err := os.Stat(p); err == nil {
				return p
			}
		}
	}
	return ""
}

func initModel() model {
	path := findDB()
	if path == "" {
		fmt.Fprintln(os.Stderr, "packages.db not found")
		os.Exit(1)
	}
	pkgs, err := readPkgs(path)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
	cats := []string{}
	catPkgs := map[string][]pkg{}
	for _, p := range pkgs {
		if _, ok := catPkgs[p.cat]; !ok {
			cats = append(cats, p.cat)
		}
		catPkgs[p.cat] = append(catPkgs[p.cat], p)
	}
	return model{
		pkgs:     pkgs,
		cats:     cats,
		catPkgs:  catPkgs,
		selected: map[string]bool{},
	}
}

func (m model) Init() tea.Cmd { return nil }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width, m.height = msg.Width, msg.Height
		return m, nil
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "esc":
			if m.state == 1 {
				m.state, m.pkgCur = 0, 0
			} else if m.state == 2 {
				m.state = 1
			}
			return m, nil
		case "enter":
			if m.state == 0 && len(m.cats) > 0 {
				m.state, m.pkgCur = 1, 0
			}
			if m.state == 1 {
				cat := m.cats[m.catCur]
				for _, p := range m.catPkgs[cat] {
					if m.selected[p.name] {
						m.state = 2
						break
					}
				}
			}
			if m.state == 2 {
				var out []string
				for _, p := range m.pkgs {
					if m.selected[p.name] {
						out = append(out, p.name)
					}
				}
				fmt.Println(strings.Join(out, "\n"))
				return m, tea.Quit
			}
		case "up", "k":
			if m.state == 0 && m.catCur > 0 {
				m.catCur--
			}
			if m.state == 1 && m.pkgCur > 0 {
				m.pkgCur--
			}
		case "down", "j":
			if m.state == 0 && m.catCur < len(m.cats)-1 {
				m.catCur++
			}
			if m.state == 1 {
				cat := m.cats[m.catCur]
				if m.pkgCur < len(m.catPkgs[cat])-1 {
					m.pkgCur++
				}
			}
		case " ", "x":
			if m.state == 1 {
				cat := m.cats[m.catCur]
				pkgs := m.catPkgs[cat]
				if m.pkgCur >= 0 && m.pkgCur < len(pkgs) {
					name := pkgs[m.pkgCur].name
					m.selected[name] = !m.selected[name]
				}
			}
		case "a":
			if m.state == 1 {
				cat := m.cats[m.catCur]
				all := true
				for _, p := range m.catPkgs[cat] {
					if !m.selected[p.name] {
						all = false
						break
					}
				}
				for _, p := range m.catPkgs[cat] {
					m.selected[p.name] = !all
				}
			}
		case "y", "Y":
			if m.state == 2 {
				var out []string
				for _, p := range m.pkgs {
					if m.selected[p.name] {
						out = append(out, p.name)
					}
				}
				fmt.Println(strings.Join(out, "\n"))
				return m, tea.Quit
			}
		case "n", "N":
			if m.state == 2 {
				m.state = 1
			}
		}
	}
	return m, nil
}

func (m model) View() string {
	switch m.state {
	case 0:
		return m.catView()
	case 1:
		return m.pkgView()
	case 2:
		return m.confirmView()
	}
	return ""
}

func (m model) catView() string {
	var b strings.Builder
	b.WriteString(titleStyle.Render("  LGET - Package Browser  "))
	b.WriteString("\n")
	b.WriteString(subtitleStyle.Render("  Select a category"))
	b.WriteString("\n\n")

	for i, cat := range m.cats {
		sel := 0
		for _, p := range m.catPkgs[cat] {
			if m.selected[p.name] {
				sel++
			}
		}
		line := fmt.Sprintf("%s (%d pkgs)", cat, len(m.catPkgs[cat]))
		if sel > 0 {
			line = fmt.Sprintf("%s (%d pkgs, %d selected)", cat, len(m.catPkgs[cat]), sel)
		}
		prefix := "  "
		if i == m.catCur {
			prefix = "▸ "
			b.WriteString(catSelStyle.Render(prefix + line))
		} else {
			b.WriteString(catStyle.Render(prefix + line))
		}
		b.WriteString("\n")
	}
	b.WriteString(helpStyle.Render("\n  ↑/↓ navigate · Enter select · q quit"))
	return b.String()
}

func (m model) pkgView() string {
	cat := m.cats[m.catCur]
	pkgs := m.catPkgs[cat]

	var b strings.Builder
	b.WriteString(titleStyle.Render("  " + cat))
	b.WriteString("\n")
	b.WriteString(helpStyle.Render("  Space=toggle · Enter=install · a=all/none · Esc=back"))
	b.WriteString("\n\n")

	max := m.height - 8
	if max < 1 {
		max = 10
	}
	start := 0
	if m.pkgCur >= max {
		start = m.pkgCur - max + 1
	}

	for i := start; i < len(pkgs) && i < start+max; i++ {
		p := pkgs[i]
		cb := checkStyle.Render("[\u2713]")
		if !m.selected[p.name] {
			cb = uncheckStyle.Render("[ ]")
		}
		line := fmt.Sprintf(" %s %-16s %s", cb, p.name, p.desc)
		if i == m.pkgCur {
			b.WriteString(pkgSelStyle.Render(line))
		} else {
			b.WriteString(pkgStyle.Render(line))
		}
		b.WriteString("\n")
	}

	sel := 0
	for _, p := range pkgs {
		if m.selected[p.name] {
			sel++
		}
	}
	b.WriteString(fmt.Sprintf("\n  %s selected: %d/%d", countStyle.Render("■"), sel, len(pkgs)))
	return b.String()
}

func (m model) confirmView() string {
	var b strings.Builder
	b.WriteString(titleStyle.Render("  Confirm Installation"))
	b.WriteString("\n\n")

	n := 0
	for _, p := range m.pkgs {
		if m.selected[p.name] {
			b.WriteString(fmt.Sprintf("  %s - %s\n", p.name, p.desc))
			n++
		}
	}
	b.WriteString(fmt.Sprintf("\n  %s %d package(s)\n", confirmStyle.Render("Total:"), n))
	b.WriteString(helpStyle.Render("\n  y/Enter=Install · n/Esc=Cancel"))
	return b.String()
}

func main() {
	m := initModel()
	p := tea.NewProgram(m, tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
