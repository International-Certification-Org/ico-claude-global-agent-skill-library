# ICO Claude Global Agents & Skills Library

This repository contains a collection of **agents**, **skills**, **runbooks** and **templates** designed for use with Claude Code CLI. These resources are intended to be installed globally on your development machine so that they can be reused across multiple projects.

## Contents

- `agents/` - role definitions describing responsibilities, inputs, outputs and guardrails for each agent.
- `skills/` - playbooks that standardise how to perform common tasks across technologies. Each skill includes a goal, checklist, minimal examples, success criteria and common failure modes.
- `runbooks/` - detailed operational guides for recurring processes such as releases, environment setup, database migrations and workflow versioning.
- `templates/` - issue and pull-request templates to streamline collaboration.

## Installation

### One-time usage

```bash
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/sync | bash
```

### Install icgasl command (for repeated use)

Interactive (asks user/global):
```bash
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/install | bash
```

User install (`~/.local/bin/icgasl`):
```bash
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/install | bash -s -- --user
```

Global install (`/usr/local/bin/icgasl`, requires sudo):
```bash
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/install | bash -s -- --global
```

Both locations (user + global):
```bash
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/install | bash -s -- --all
```

### Usage

```bash
icgasl                   # Install/update agents & skills
icgasl --dry-run         # Show what would change without applying
icgasl --only-agents     # Install only agents
icgasl --only-skills     # Install only skills
icgasl --only-runbooks   # Install only runbooks
icgasl --only-templates  # Install only templates
icgasl --backup          # Create backup before updating
icgasl --uninstall       # Remove all installed files
icgasl --verbose         # Show detailed debug output
icgasl --version         # Show version
icgasl --help            # Show this help
```

The sync copies `agents/`, `skills/`, `runbooks/` and `templates/` to `~/.config/claude` or `~/.claude`.

## Security

Downloads are protected by:
- **HTTPS enforcement** - All downloads require HTTPS
- **Domain whitelist** - Only `github.com` and `raw.githubusercontent.com` are trusted
- **Checksum verification** - Release tarballs are verified against SHA256 checksums
- **Versioned releases** - Downloads use tagged versions for reproducibility

Checksums for releases are available in `checksums.sha256`.

## Usage in Prompts

Once installed, you can reference these definitions in your prompts to Claude Code CLI. For example:

- *"Use the Bash secure script standard to implement the installer."*
- *"As the Orchestrator, check the available MCP servers and provide an MCP Availability Handoff."*

The Orchestrator agent is responsible for discovering which MCP servers are available in your session and publishing that information in its planning outputs. All other agents rely on this declaration and do not probe MCP servers on their own.

## License

This library is provided under the MIT License. See the `LICENSE` file for details.
