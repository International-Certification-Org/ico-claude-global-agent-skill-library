---
allowed-tools: Bash
description: Push local c-ico-prefixed items (skills, agents, commands, runbooks) from ~/.claude/ to the ICO Git repository. Auto-commits and pushes. Supports --dry-run, --message, --only-skills, --only-agents, --only-commands, --only-runbooks, --verbose.
---

# /c-ico-cm-library-push -- Push c-ico items from local to ICO repo

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
