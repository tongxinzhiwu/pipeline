# Pipeline CLI

A kubectl-style CLI for the Makeblock Pipeline CI/CD system. Manage projects, trigger pipelines, stream logs, and check build status — all from your terminal.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/tongxinzhiwu/pipeline/main/install.sh | bash
```

The install script automatically detects your OS and architecture, downloads the latest release, and adds the binary to your PATH.

## Manual Installation

1. Go to <https://github.com/tongxinzhiwu/pipeline/releases>
2. Download the appropriate `pipeline-{OS}-{ARCH}.tar.gz` for your platform
3. Extract the archive:
   ```bash
   tar -xzf pipeline-{OS}-{ARCH}.tar.gz
   ```
4. Move the binary to a directory in your PATH:
   ```bash
   mv pipeline-{OS}-{ARCH}/pipeline /usr/local/bin/
   ```
   Or install to the user-local directory:
   ```bash
   mkdir -p ~/.pipeline && mv pipeline-{OS}-{ARCH}/pipeline ~/.pipeline/
   ```
5. Verify the installation:
   ```bash
   pipeline --version
   ```

### Supported Platforms

| OS      | Architecture | Archive Name                     |
|---------|-------------|----------------------------------|
| Linux   | amd64       | `pipeline-linux-amd64.tar.gz`    |
| Linux   | armv7       | `pipeline-linux-armv7.tar.gz`    |
| Linux   | arm64       | `pipeline-linux-arm64.tar.gz`    |
| macOS   | amd64       | `pipeline-darwin-amd64.tar.gz`   |
| macOS   | arm64       | `pipeline-darwin-arm64.tar.gz`   |
| Windows | amd64       | `pipeline-windows-amd64.tar.gz`  |
| Windows | arm64       | `pipeline-windows-arm64.tar.gz`  |

### Platform Notes

- **macOS:** You may need to bypass Gatekeeper after extracting:
  ```bash
  xattr -d com.apple.quarantine pipeline
  ```
- **Windows:** Download the `.tar.gz` file, extract with 7-Zip or WSL, and add the directory containing `pipeline.exe` to your PATH manually.
- **Linux ARM:** For Raspberry Pi, use `armv7` (32-bit OS) or `arm64` (64-bit OS).

## Configuration

After installation, configure the CLI to connect to your Pipeline server:

```bash
# Set the server URL
pipeline config set-server https://pipeline.makeblock.com

# Set authentication credentials
pipeline config set-credentials --ak <access-key> --sk <secret-key>

# Set a default project so you don't have to specify it every time
pipeline config set-default-project <project-name>

# View current configuration
pipeline config view
```

Configuration is stored in `~/.pipeline/config.yaml`.

## Upgrade

Re-run the install script to upgrade to the latest version:

```bash
curl -fsSL https://raw.githubusercontent.com/tongxinzhiwu/pipeline/main/install.sh | bash
```

## Uninstall

```bash
rm -rf ~/.pipeline
# Remove the PATH entry from ~/.profile (or ~/.bashrc, ~/.zshrc)
```

## Usage

```bash
# Show help
pipeline --help

# List projects and apps
pipeline get projects
pipeline get apps

# Trigger a pipeline and wait for it to complete
pipeline trigger <app> --branch main --wait

# Stream build logs in real time
pipeline logs <app> --follow

# Check the latest pipeline status
pipeline status <app>
```

For the complete command reference, see the [CLI Skill Reference](../skill/SKILL-CLI.md).
