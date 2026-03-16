---
name: my-ico-library-push
description: >
  Push local my-ico-prefixed items (skills, agents, commands, runbooks) from ~/.claude/ to the
  ICO Git repository. Auto-commits and pushes. Use when the user says "ico push", "push ico skills",
  or wants to sync ICO items from local to the repo.
argument-hint: "[--dry-run] [--force] [--message \"msg\"] [--only-skills] [--clean] [--verbose]"
---

# /my-ico-library-push — Push my-ico-items from local to ICO repo

Run the `my-ico-library-push` command to synchronise custom `my-ico-` items from the local `~/.claude/` directory to the ICO Git repository.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
my-ico-library-push $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If items exist in the repo but not locally, mention them (manual cleanup needed)
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes
