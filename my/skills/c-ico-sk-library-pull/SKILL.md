---
name: c-ico-sk-library-pull
description: >
  Pull c-ico-prefixed items (skills, agents, commands, runbooks) from the ICO Git repository
  to local ~/.claude/. Use when the user says "ico pull", "pull ico skills", or wants to sync
  ICO items from the repo to local.
allowed-tools: Bash
argument-hint: "[--dry-run] [--force] [--clean] [--only-skills] [--verbose]"
---

# /c-ico-sk-library-pull — Pull c-ico items from ICO repo to local

Run the `c-ico-library-pull` command to synchronise ICO items from the Git repository to local `~/.claude/`.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
c-ico-library-pull $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes (e.g., "run `git pull` in the repo first")
