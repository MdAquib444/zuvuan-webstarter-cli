#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
readonly PROMPT_NAME="Enter your project name: "
readonly PROMPT_AUTHOR="Enter author name (for LICENSE) [Project Author]: "
readonly MAX_NAME_LEN=100
CREATED_ROOT=""
log_info() {
  printf '[INFO] %s\n' "$1"
}
log_error() {
  printf '[ERROR] %s\n' "$1" >&2
}
on_exit() {
  local exit_code=$?
  trap - EXIT INT TERM
  if [[ "${exit_code}" -ne 0 && -n "${CREATED_ROOT}" && -d "${CREATED_ROOT}" ]]; then
    log_error "Setup failed or interrupted (exit ${exit_code}). Cleaning up '${CREATED_ROOT}'..."
    rm -rf -- "${CREATED_ROOT}" || true
  fi
  exit "${exit_code}"
}
trap on_exit EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
validate_project_name() {
  local name="$1"
  if [[ -z "${name}" ]]; then
    log_error "Project name cannot be empty."
    return 1
  fi
  if (( ${#name} > MAX_NAME_LEN )); then
    log_error "Project name is too long (max ${MAX_NAME_LEN} characters)."
    return 1
  fi
  if [[ "${name}" == "." || "${name}" == ".." ]]; then
    log_error "Project name cannot be '.' or '..'."
    return 1
  fi
  if [[ ! "${name}" =~ ^[A-Za-z0-9._-]+$ ]]; then
    log_error "Project name may only contain letters, numbers, dots, underscores, and hyphens."
    return 1
  fi
  if [[ -e "./${name}" || -L "./${name}" ]]; then
    log_error "Target '${name}' already exists."
    return 1
  fi
  return 0
}
validate_author() {
  local author="$1"
  if (( ${#author} > MAX_NAME_LEN )) || [[ "${author}" =~ [[:cntrl:]] ]]; then
    log_error "Author name is too long or has invalid characters."
    return 1
  fi
  return 0
}
write_file_atomic() {
  local target_path="$1"
  local content="$2"
  local tmp_file
  tmp_file="$(mktemp "${target_path}.tmp.XXXXXX")"
  printf '%s\n' "${content}" > "${tmp_file}"
  chmod 0644 "${tmp_file}"
  mv -f -- "${tmp_file}" "${target_path}"
}
main() {
  if [[ ! -t 0 ]]; then
    log_error "Standard input is not a terminal."
    exit 1
  fi
  local project_name author
  read -r -p "${PROMPT_NAME}" project_name || {
    log_error "Failed to read input."
    exit 1
  }
  validate_project_name "${project_name}" || exit 1
  read -r -p "${PROMPT_AUTHOR}" author || {
    log_error "Failed to read input."
    exit 1
  }
  author="${author:-Project Author}"
  validate_author "${author}" || exit 1
  local year
  year="$(date +%Y)"
  local target_dir="./${project_name}"
  mkdir -- "${target_dir}"
  CREATED_ROOT="${target_dir}"
  mkdir -p -- \
    "${target_dir}/JavaScript" \
    "${target_dir}/Styles" \
    "${target_dir}/lib" \
    "${target_dir}/Assets/fonts" \
    "${target_dir}/Assets/icons" \
    "${target_dir}/Assets/other"
  local keep_dir
  for keep_dir in lib Assets/fonts Assets/icons Assets/other; do
    : > "${target_dir}/${keep_dir}/.gitkeep"
  done
  local html_content
  html_content=$(cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>__NAME__</title>
  <link rel="stylesheet" href="./Styles/main.css" />
</head>
<body>
  <main class="container" role="main">
    <h1>Hello World</h1>
    <p id="message" aria-live="polite">Initializing...</p>
  </main>
  <script src="./JavaScript/main.js" defer></script>
</body>
</html>
EOF
)
  html_content="${html_content//__NAME__/"${project_name}"}"
  local css_content
  css_content=$(cat <<'EOF'
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

:root {
  --bg-page: #f4f6f9;
  --bg-card: #ffffff;
  --text-primary: #1e293b;
  --shadow-card: 0 8px 24px rgba(15, 23, 42, 0.08);
}

body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  display: grid;
  place-items: center;
  min-height: 100dvh;
  background-color: var(--bg-page);
  color: var(--text-primary);
  line-height: 1.5;
}

.container {
  text-align: center;
  padding: 2rem;
  border-radius: 12px;
  background-color: var(--bg-card);
  box-shadow: var(--shadow-card);
  max-width: 90vw;
}
EOF
)
  local js_content
  js_content=$(cat <<'EOF'
"use strict";

(() => {
  const renderGreeting = () => {
    const messageEl = document.getElementById("message");
    if (!messageEl) {
      return;
    }
    messageEl.textContent = "Hello from JavaScript!";
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", renderGreeting, { once: true });
  } else {
    renderGreeting();
  }
})();
EOF
)
  local license_content
  license_content=$(cat <<'EOF'
MIT License

Copyright (c) __YEAR__ __AUTHOR__

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
)
  license_content="${license_content//__YEAR__/"${year}"}"
  license_content="${license_content//__AUTHOR__/"${author}"}"
  local readme_content
  readme_content=$(cat <<'EOF'
# __NAME__

A simple static web project (HTML, CSS, JavaScript).

## Project Structure

```
__NAME__/
├── index.html
├── JavaScript/
│   └── main.js
├── Styles/
│   └── main.css
├── lib/              # third-party libraries
└── Assets/
    ├── fonts/
    ├── icons/
    └── other/
```

## Getting Started

1. Clone or download this repository.
2. Open `index.html` in your browser.

For a local server (optional):

```bash
python3 -m http.server 8000
```

Then visit <http://localhost:8000>.

## Contributing

Contributions are welcome. Fork the repo, create a branch, and open a pull request.

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
EOF
)
  readme_content="${readme_content//__NAME__/"${project_name}"}"
  local gitignore_content
  gitignore_content=$(cat <<'EOF'
.DS_Store
Thumbs.db
node_modules/
*.log
*.tmp.*
.vscode/
.idea/
EOF
)
  write_file_atomic "${target_dir}/index.html" "${html_content}"
  write_file_atomic "${target_dir}/Styles/main.css" "${css_content}"
  write_file_atomic "${target_dir}/JavaScript/main.js" "${js_content}"
  write_file_atomic "${target_dir}/LICENSE.txt" "${license_content}"
  write_file_atomic "${target_dir}/README.md" "${readme_content}"
  write_file_atomic "${target_dir}/.gitignore" "${gitignore_content}"
  CREATED_ROOT=""
  log_info "Project '${project_name}' created successfully."
}
main "$@"