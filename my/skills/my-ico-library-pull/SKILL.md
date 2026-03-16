---
name: my-ico-library-pull
description: >
  Pull my-ico-prefixed items (skills, agents, commands, runbooks) from the ICO Git repository
  to local ~/.claude/. Use when the user says "ico pull", "pull ico skills", or wants to sync
  ICO items from the repo to local.
argument-hint: "[--dry-run] [--force] [--clean] [--only-skills] [--verbose]"
---

# /my-ico-library-pull — Pull my-ico-items from ICO repo to local

Run the `my-ico-library-pull` command to synchronise custom `my-ico-` items from the ICO Git repository to the local `~/.claude/` directory.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
my-ico-library-pull $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes (e.g., "run `git pull` in the repo first")
