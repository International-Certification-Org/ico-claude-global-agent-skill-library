---
allowed-tools: Bash
description: Push local my-ico-prefixed items (skills, agents, commands, runbooks) from ~/.claude/ to the Git repository. Auto-commits and pushes. Supports --dry-run, --message, --only-skills, --only-agents, --only-commands, --only-runbooks, --verbose.
---

# /my-ico-library-push -- Push my-ico-items from local to repo

Run the `my-ico-library-push` command to synchronise custom `my-ico-` items from the local `~/.claude/` directory to the Git repository.

Pass any arguments the user provided via `$ARGUMENTS`.

```bash
my-ico-library-push $ARGUMENTS
```

After execution, summarise:
- How many items were new, modified, unchanged
- If items exist in the repo but not locally, mention them (manual cleanup needed)
- If `--dry-run` was used, note that no changes were made
- If errors occurred, suggest fixes
