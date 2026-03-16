---
name: c-ico-sk-library-push
description: >
  Push local c-ico-prefixed items (skills, agents, commands, runbooks) from ~/.claude/ to the
  ICO Git repository. Auto-commits and pushes. Use when the user says "ico push", "push ico skills",
  or wants to sync ICO items from local to the repo.
allowed-tools: Bash
argument-hint: "[--dry-run] [--force] [--message \"msg\"] [--only-skills] [--clean] [--verbose]"
---

# /c-ico-sk-library-push — Push c-ico items from local to ICO repo

Run the `c-ico-library-push` command to synchronise ICO items from local `~/.claude/` to the Git repository.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
c-ico-library-push $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If items exist in the repo but not locally, mention them (manual cleanup needed)
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes
