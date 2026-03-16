---
allowed-tools: Bash
description: Pull c-ico-prefixed items (skills, agents, commands, runbooks) from the ICO Git repository to local ~/.claude/. Supports --dry-run, --only-skills, --only-agents, --only-commands, --only-runbooks, --verbose.
---

# /c-ico-cm-library-pull -- Pull c-ico items from ICO repo to local

Run the `c-ico-library-pull` command to synchronise ICO items from the Git repository to local `~/.claude/`.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
c-ico-library-pull $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes (e.g., "run `git pull` in the repo first")
