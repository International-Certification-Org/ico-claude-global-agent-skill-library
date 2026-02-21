# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **International Certification Organization (ICO)** global agents and skills library for Claude Code CLI. It contains reusable role definitions (agents), task playbooks (skills), operational guides (runbooks), and collaboration templates. These resources are installed globally on development machines and referenced across multiple projects.

## Architecture

### Directory Structure

- `agents/` - Role definitions with responsibilities, inputs, outputs, and guardrails
- `skills/` - Standardized playbooks for common tasks with checklists and success criteria
- `runbooks/` - Detailed operational guides for recurring processes
- `templates/` - Issue and PR templates

### Agent Hierarchy

The **Orchestrator (A01)** coordinates all work:
- Discovers MCP server availability and publishes an **MCP Availability Handoff**
- Decomposes goals into tasks with acceptance criteria
- Assigns work to implementer agents

Implementer agents rely on the Orchestrator's plan and MCP handoff:
- **A02 Backend/Automation** - Bash scripts and backend development
- **A03 Workflow/Integration** - Workflow automation and REST APIs
- **A04 Data** - Database migrations and caching strategies
- **A05 Security** - AppSec reviews, TLS/HTTP headers
- **A06 QA** - Test harness development and execution

### Key Patterns

All agents follow these conventions:
- Never probe MCP servers independently; rely on Orchestrator's handoff
- Never hardcode secrets; use `.env` files
- Scripts must be idempotent
- Handoff protocols include required context for downstream agents

## Installation

```bash
# Install icgasl command (choose user or global)
curl -fsSL https://raw.githubusercontent.com/International-Certification-Org/ico-claude-global-agent-skill-library/main/install | bash

# Then use
icgasl         # Install/update agents & skills
```

The sync copies to `~/.config/claude` or `~/.claude`.

## Usage Examples

Reference agents and skills in prompts:
- *"Use the Bash secure script standard to implement the installer."*
- *"As the Orchestrator, check the available MCP servers and provide an MCP Availability Handoff."*

## Technology Stack

- **Bash** - Automation scripts with strict mode (`set -euo pipefail`)
- **Python/JavaScript** - Backend and scripting languages
- **Database** - Forward-only migrations
- **REST APIs** - Integration with external services

## Mandatory: Milestone-Based Issue Lifecycle

**All issues in this repo MUST follow the milestone-based lifecycle. No exceptions.**

Every issue gets exactly ONE milestone at a time representing its current state. Milestones are progressed in order — no skipping states.

### Lifecycle Flow

```
new -> planned -> plan-approved -> test-designed -> test-design-approved
  -> implemented -> tested-success / tested-failed -> test-approved -> DONE
```

### Milestone Definitions

| Milestone | Set By | Meaning |
|-----------|--------|---------|
| `new` | Team Lead | Issue created, not yet planned |
| `planned` | Team Lead | Agent submitted a plan (posted as issue comment) |
| `plan-approved` | Team Lead + Codex | Both reviewed and approved the plan |
| `test-designed` | Team Lead | Agent submitted test design as issue comment |
| `test-design-approved` | Team Lead + Codex | Both approved test design |
| `implemented` | Team Lead | Code written, agent reports completion |
| `tested-success` | Team Lead | All tests pass |
| `tested-failed` | Team Lead | Tests fail — bounces back with documented reason |
| `test-approved` | Team Lead + Codex | Final automated gate — independent verification passed |
| `DONE` | **Human only** | Final sign-off. Agents NEVER set this. |

### Non-Negotiable Rules

1. **One milestone at a time** per issue — no skipping states
2. **Dual approval required** at every gate — Team Lead AND Codex must both approve
3. **`DONE` is human-only** — agents must NEVER set this milestone
4. **One issue per discrete change** — all phases documented as comments on that issue
5. **Audit trail** — every Codex response posted as comment on the GitHub Issue
6. **On failure**: `tested-failed` bounces back to `planned` (wrong approach) or `implemented` (code bug), with documented reason
7. **If Codex unavailable**: STOP and notify user. Do NOT proceed without Codex review.
