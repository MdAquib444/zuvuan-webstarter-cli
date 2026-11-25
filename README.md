# zuvuan-webstarter-cli

> One command, one prompt, and your project folder is ready: structured folders, starter files, license, and docs. No dependencies.

![Shell](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue)
![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20(WSL)-lightgrey)

## Overview

`zuvuan-webstarter-cli` is a lightweight Bash script that scaffolds a clean static web project (HTML, CSS, JavaScript) in seconds. It asks for a project name and an author name, then generates a ready-to-use folder with starter files, an MIT `LICENSE.txt`, a `README.md`, and a `.gitignore`.

## Features

- Interactive prompts for project name and author
- Strict project-name validation (safe folder names only)
- Ready-to-open `index.html` with linked CSS and JS
- Auto-generated MIT `LICENSE.txt` (current year + your name)
- Auto-generated project `README.md` and `.gitignore`
- Organized folders for scripts, styles, libraries, and assets
- Atomic file writes and automatic cleanup if setup fails or is interrupted (Ctrl+C)
- Never overwrites an existing folder
- Zero dependencies, just Bash

## Requirements

- Bash 3.2 or newer (preinstalled on Linux and macOS)
- Windows: [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/windows/wsl/install)
- An interactive terminal (the script will not run with piped input)

## Download

**Option 1: Clone with Git**

```bash
git clone https://github.com/MdAquib444/zuvuan-webstarter-cli.git
cd zuvuan-webstarter-cli
```

**Option 2: Download ZIP**

[Download the latest ZIP](https://github.com/MdAquib444/zuvuan-webstarter-cli/archive/refs/heads/main.zip), extract it, and open the folder in your terminal.

**Option 3: Download only the script**

```bash
curl -O https://raw.githubusercontent.com/MdAquib444/zuvuan-webstarter-cli/main/zuvuan.sh
```

## Usage

1. Make the script executable (first time only):

   ```bash
   chmod +x zuvuan.sh
   ```

2. Run it from the folder where you want your new project to be created:

   ```bash
   ./zuvuan.sh
   ```

   Or without changing permissions:

   ```bash
   bash zuvuan.sh
   ```

3. Answer the prompts:

   ```text
   Enter your project name: my-website
   Enter author name (for LICENSE) [Project Author]: Your Name
   [INFO] Project 'my-website' created successfully.
   ```

4. Open your project:

   ```bash
   cd my-website
   ```

   Then open `index.html` in your browser, or start a local server:

   ```bash
   python3 -m http.server 8000
   ```

   Visit <http://localhost:8000>.

> Tip: to run it from anywhere, copy the script to a folder in your `PATH`, for example `cp zuvuan.sh ~/.local/bin/zuvuan`.

## Generated Structure

```text
my-website/
├── index.html
├── LICENSE.txt
├── README.md
├── .gitignore
├── JavaScript/
│   └── main.js
├── Styles/
│   └── main.css
├── lib/
└── Assets/
    ├── fonts/
    ├── icons/
    └── other/
```

Empty folders contain a `.gitkeep` file so Git keeps them.

## Project Name Rules

| Rule | Details |
| --- | --- |
| Allowed characters | Letters, numbers, dots (`.`), underscores (`_`), hyphens (`-`) |
| Length | Up to 100 characters |
| Not allowed | Empty names, `.`, `..`, spaces, slashes, special characters |
| Existing folder | Script stops if the folder already exists |

## Troubleshooting

| Problem | Solution |
| --- | --- |
| `Permission denied` | Run `chmod +x zuvuan.sh` or use `bash zuvuan.sh` |
| `Standard input is not a terminal` | Run the script directly in a terminal, not through a pipe |
| `Target '...' already exists` | Choose a different project name or remove the existing folder |
| Windows: script not running | Use Git Bash or WSL, not Command Prompt or PowerShell |
| `bad interpreter` / `\r` errors | Convert line endings: `sed -i 's/\r$//' zuvuan.sh` |

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push the branch: `git push origin feature/your-feature`
5. Open a Pull Request

Found a bug or have an idea? [Open an issue](https://github.com/MdAquib444/zuvuan-webstarter-cli/issues).

## License

Released under the MIT License. See [LICENSE.txt](./LICENSE.txt) for details.

## Author

**Md Aquib**

- GitHub: [@MdAquib444](https://github.com/MdAquib444)

If this project helped you, consider giving it a star on GitHub.