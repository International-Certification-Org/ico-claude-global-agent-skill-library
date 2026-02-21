#!/usr/bin/env bash
#
# run_tests.sh - Test suite for ICO Claude Global Agents & Skills Library
#
# Usage: bash tests/run_tests.sh
#
# Outputs TAP-compatible results. Exits 0 on all pass, 1 on any failure.

set -euo pipefail

# Resolve repo root (parent of tests/)
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$TESTS_DIR/.." && pwd)"

# Source helpers
source "$TESTS_DIR/test_helpers.sh"

echo "TAP version 13"
echo "# ICO Claude Global Agents & Skills Library — Test Suite"
echo "# Repo: ${REPO_DIR}"
echo ""

# ─────────────────────────────────────────────
# Group 1: Content Existence Verification
# ─────────────────────────────────────────────
echo "# --- Group 1: Content Existence ---"

# 1.1 agents/ has .md files
agent_count=$(find "$REPO_DIR/agents" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l)
assert_gt "agents/ contains at least 1 .md file" "$agent_count" 0

# 1.2 skills/ has directories with SKILL.md
skill_count=$(find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name "SKILL.md" -type f 2>/dev/null | wc -l)
assert_gt "skills/ contains at least 1 SKILL.md" "$skill_count" 0

# 1.3 runbooks/ has .md files
runbook_count=$(find "$REPO_DIR/runbooks" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l)
assert_gt "runbooks/ contains at least 1 .md file" "$runbook_count" 0

# 1.4 templates/ has .md files
template_count=$(find "$REPO_DIR/templates" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l)
assert_gt "templates/ contains at least 1 .md file" "$template_count" 0

# ─────────────────────────────────────────────
# Group 2: SKILL.md Frontmatter Validation
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 2: SKILL.md Frontmatter ---"

all_frontmatter_ok=true
while IFS= read -r -d '' skillfile; do
  skill_name="$(basename "$(dirname "$skillfile")")"

  # 2.1 Starts with ---
  first_line="$(head -1 "$skillfile")"
  if [[ "$first_line" == "---" ]]; then
    pass "SKILL.md frontmatter opens with --- [${skill_name}]"
  else
    fail "SKILL.md frontmatter opens with --- [${skill_name}]" "first line: '${first_line}'"
    all_frontmatter_ok=false
  fi

  # 2.2 Has closing ---
  # Find the second occurrence of --- (line number > 1)
  closing_line=$(awk 'NR > 1 && /^---$/ { print NR; exit }' "$skillfile")
  if [[ -n "$closing_line" ]]; then
    pass "SKILL.md frontmatter closes with --- [${skill_name}]"
  else
    fail "SKILL.md frontmatter closes with --- [${skill_name}]" "no closing --- found"
    all_frontmatter_ok=false
  fi

  # 2.3 Has name: field
  # Extract frontmatter (between first and second ---)
  frontmatter=$(awk 'NR==1 && /^---$/ {found=1; next} found && /^---$/ {exit} found {print}' "$skillfile")
  if echo "$frontmatter" | grep -q "^name:"; then
    pass "SKILL.md has name: field [${skill_name}]"
  else
    fail "SKILL.md has name: field [${skill_name}]"
    all_frontmatter_ok=false
  fi

  # 2.4 Has description: field
  if echo "$frontmatter" | grep -q "^description:"; then
    pass "SKILL.md has description: field [${skill_name}]"
  else
    fail "SKILL.md has description: field [${skill_name}]"
    all_frontmatter_ok=false
  fi
done < <(find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name "SKILL.md" -type f -print0 | sort -z)

# ─────────────────────────────────────────────
# Group 3: Flag Parsing in sync
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 3: Flag Parsing (sync) ---"

sync_content="$(cat "$REPO_DIR/sync")"

# 3.1 --local flag recognized
if echo "$sync_content" | grep -q -- '--local)'; then
  pass "sync recognizes --local flag"
else
  fail "sync recognizes --local flag"
fi

# 3.2 --global flag recognized
if echo "$sync_content" | grep -q -- '--global)'; then
  pass "sync recognizes --global flag"
else
  fail "sync recognizes --global flag"
fi

# 3.3 --dry-run flag recognized
if echo "$sync_content" | grep -q -- '--dry-run)'; then
  pass "sync recognizes --dry-run flag"
else
  fail "sync recognizes --dry-run flag"
fi

# 3.4 --backup flag recognized
if echo "$sync_content" | grep -q -- '--backup)'; then
  pass "sync recognizes --backup flag"
else
  fail "sync recognizes --backup flag"
fi

# 3.5 --uninstall flag recognized
if echo "$sync_content" | grep -q -- '--uninstall)'; then
  pass "sync recognizes --uninstall flag"
else
  fail "sync recognizes --uninstall flag"
fi

# 3.6 --verbose flag recognized
if echo "$sync_content" | grep -q -- '--verbose)'; then
  pass "sync recognizes --verbose flag"
else
  fail "sync recognizes --verbose flag"
fi

# 3.7 Unknown flags have a catch-all case
if echo "$sync_content" | grep -q '^\s*\*)'; then
  pass "sync has catch-all case for unknown flags"
else
  fail "sync has catch-all case for unknown flags"
fi

# ─────────────────────────────────────────────
# Group 4: Target Directory Resolution (lib.sh)
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 4: Target Directory Resolution ---"

# Create isolated temp HOME for lib.sh tests
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT

# 4.1 get_target_dir returns ~/.config/claude when it exists
mkdir -p "$TEST_HOME/.config/claude"
result=$(HOME="$TEST_HOME" VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && get_target_dir")
assert_eq "get_target_dir returns ~/.config/claude when it exists" "$TEST_HOME/.config/claude" "$result"

# 4.2 get_target_dir returns ~/.claude as fallback
TEST_HOME2="$(mktemp -d)"
result=$(HOME="$TEST_HOME2" VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && get_target_dir")
assert_eq "get_target_dir returns ~/.claude as fallback" "$TEST_HOME2/.claude" "$result"
rm -rf "$TEST_HOME2"

# 4.3 get_local_target_dir returns ./.claude
result=$(VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && get_local_target_dir")
assert_eq "get_local_target_dir returns ./.claude" "./.claude" "$result"

# 4.4 resolve_target_dirs 1 0 returns local only
result=$(HOME="$TEST_HOME" VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 1 0")
assert_eq "resolve_target_dirs(local=1,global=0) returns local dir" "./.claude" "$result"

# 4.5 resolve_target_dirs 0 1 returns global only
result=$(HOME="$TEST_HOME" VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 0 1")
assert_eq "resolve_target_dirs(local=0,global=1) returns global dir" "$TEST_HOME/.config/claude" "$result"

# 4.6 resolve_target_dirs 1 1 returns both
result=$(HOME="$TEST_HOME" VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 1 1")
line_count=$(echo "$result" | wc -l)
assert_eq "resolve_target_dirs(local=1,global=1) returns 2 lines" "2" "$line_count"
assert_contains "resolve_target_dirs(both) includes global dir" "$result" "$TEST_HOME/.config/claude"
assert_contains "resolve_target_dirs(both) includes local dir" "$result" "./.claude"

# 4.7 ICGASL_TARGET=local overrides default
result=$(HOME="$TEST_HOME" VERBOSE=0 ICGASL_TARGET=local bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 0 0" </dev/null)
assert_eq "ICGASL_TARGET=local returns local dir" "./.claude" "$result"

# 4.8 ICGASL_TARGET=global overrides default
result=$(HOME="$TEST_HOME" VERBOSE=0 ICGASL_TARGET=global bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 0 0" </dev/null)
assert_eq "ICGASL_TARGET=global returns global dir" "$TEST_HOME/.config/claude" "$result"

# 4.9 Invalid ICGASL_TARGET returns error
if HOME="$TEST_HOME" VERBOSE=0 ICGASL_TARGET=invalid bash -c "source '$REPO_DIR/lib.sh' && resolve_target_dirs 0 0" </dev/null 2>/dev/null; then
  fail "invalid ICGASL_TARGET returns error"
else
  pass "invalid ICGASL_TARGET returns error"
fi

# ─────────────────────────────────────────────
# Group 5: Security — No Secrets Leaked
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 5: Security ---"

# 5.1 No .env files in repo (excluding .git)
env_files=$(find "$REPO_DIR" -name ".env" -not -path "*/.git/*" 2>/dev/null | wc -l)
assert_eq "no .env files in repo" "0" "$env_files"

# 5.2 No hardcoded API keys/tokens in scripts (exclude docs/skills which have examples)
secret_hits=$(grep -r -l -E "(api_key|api_secret|apikey|secret_key|access_token|private_key)\s*=" \
  --include="*.sh" --include="*.json" --include="*.yml" --include="*.yaml" \
  "$REPO_DIR" 2>/dev/null | grep -v "/.git/" | grep -v "/tests/" | grep -v "/skills/" || true)
if [[ -z "$secret_hits" ]]; then
  pass "no hardcoded API key/secret patterns in code"
else
  fail "no hardcoded API key/secret patterns in code" "found in: ${secret_hits}"
fi

# 5.3 No private keys in repo
privkey_hits=$(grep -r -l "BEGIN.*PRIVATE KEY" "$REPO_DIR" --include="*.pem" --include="*.key" 2>/dev/null | grep -v "/.git/" | grep -v "/tests/" || true)
if [[ -z "$privkey_hits" ]]; then
  pass "no private key files in repo"
else
  fail "no private key files in repo" "found in: ${privkey_hits}"
fi

# 5.4 validate_url rejects non-HTTPS
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_url 'http://example.com/file'" 2>/dev/null; then
  fail "validate_url rejects http:// URLs"
else
  pass "validate_url rejects http:// URLs"
fi

# 5.5 validate_url rejects untrusted domains
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_url 'https://evil.com/payload'" 2>/dev/null; then
  fail "validate_url rejects untrusted domains"
else
  pass "validate_url rejects untrusted domains"
fi

# 5.6 validate_url accepts trusted domain
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_url 'https://github.com/test'" 2>/dev/null; then
  pass "validate_url accepts trusted github.com domain"
else
  fail "validate_url accepts trusted github.com domain"
fi

# 5.7 validate_path rejects directory traversal
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_path '../etc/passwd'" 2>/dev/null; then
  fail "validate_path rejects .. traversal"
else
  pass "validate_path rejects .. traversal"
fi

# ─────────────────────────────────────────────
# Group 6: Lib.sh Utility Functions
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 6: Lib.sh Utilities ---"

# 6.1 validate_filename rejects filenames with /
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_filename 'path/file.txt'" 2>/dev/null; then
  fail "validate_filename rejects filenames with /"
else
  pass "validate_filename rejects filenames with /"
fi

# 6.2 validate_filename rejects filenames starting with -
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_filename '-badname'" 2>/dev/null; then
  fail "validate_filename rejects filenames starting with -"
else
  pass "validate_filename rejects filenames starting with -"
fi

# 6.3 validate_filename accepts valid filename
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && validate_filename 'good_file.txt'" >/dev/null 2>&1; then
  pass "validate_filename accepts valid filename"
else
  fail "validate_filename accepts valid filename"
fi

# 6.4 command_exists returns 0 for bash
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && command_exists bash"; then
  pass "command_exists returns 0 for bash"
else
  fail "command_exists returns 0 for bash"
fi

# 6.5 command_exists returns 1 for nonexistent command
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && command_exists nonexistent_cmd_xyz_12345"; then
  fail "command_exists returns 1 for nonexistent command"
else
  pass "command_exists returns 1 for nonexistent command"
fi

# 6.6 require_commands returns 0 for available commands
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && require_commands bash cat" 2>/dev/null; then
  pass "require_commands returns 0 for available commands"
else
  fail "require_commands returns 0 for available commands"
fi

# 6.7 require_commands returns 1 for missing commands
if VERBOSE=0 bash -c "source '$REPO_DIR/lib.sh' && require_commands nonexistent_abc_999" 2>/dev/null; then
  fail "require_commands returns 1 for missing commands"
else
  pass "require_commands returns 1 for missing commands"
fi

# ─────────────────────────────────────────────
# Group 7: Directory-Based Skills Structure
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 7: Directory-Based Skills ---"

# 7.1 At least one skill directory has multiple files (complex skill)
max_files=0
while IFS= read -r -d '' skilldir; do
  file_count=$(find "$skilldir" -type f | wc -l)
  if [[ "$file_count" -gt "$max_files" ]]; then
    max_files="$file_count"
  fi
done < <(find "$REPO_DIR/skills" -mindepth 1 -maxdepth 1 -type d -print0)
assert_gt "at least one skill has multiple files (complex skill)" "$max_files" 1

# 7.2 No symlinks pointing outside repo in skills/
bad_symlinks=$(find "$REPO_DIR/skills" -type l 2>/dev/null | while read -r link; do
  target=$(readlink -f "$link" 2>/dev/null || true)
  if [[ -n "$target" ]] && [[ "$target" != "$REPO_DIR"* ]]; then
    echo "$link"
  fi
done)
if [[ -z "$bad_symlinks" ]]; then
  pass "no symlinks pointing outside repo in skills/"
else
  fail "no symlinks pointing outside repo in skills/" "found: ${bad_symlinks}"
fi

# 7.3 All SKILL.md files are non-empty
empty_skills=""
while IFS= read -r -d '' skillfile; do
  if [[ ! -s "$skillfile" ]]; then
    empty_skills="${empty_skills} $(basename "$(dirname "$skillfile")")"
  fi
done < <(find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name "SKILL.md" -type f -print0)
if [[ -z "$empty_skills" ]]; then
  pass "all SKILL.md files are non-empty"
else
  fail "all SKILL.md files are non-empty" "empty:${empty_skills}"
fi

# ─────────────────────────────────────────────
# Group 8: Script Safety Checks
# ─────────────────────────────────────────────
echo ""
echo "# --- Group 8: Script Safety ---"

# 8.1 Executable bash scripts use set -euo pipefail (lib.sh excluded — it's a sourced library)
for script in sync icgasl install; do
  script_path="$REPO_DIR/$script"
  if [[ -f "$script_path" ]]; then
    if grep -q "set -euo pipefail" "$script_path"; then
      pass "${script} uses set -euo pipefail"
    else
      fail "${script} uses set -euo pipefail"
    fi
  fi
done

# 8.2 sync sources lib.sh
if grep -q 'source.*lib\.sh' "$REPO_DIR/sync"; then
  pass "sync sources lib.sh"
else
  fail "sync sources lib.sh"
fi

# 8.3 icgasl has --help handler
if grep -q -- '--help' "$REPO_DIR/icgasl"; then
  pass "icgasl supports --help"
else
  fail "icgasl supports --help"
fi

# 8.4 icgasl has --version handler
if grep -q -- '--version' "$REPO_DIR/icgasl"; then
  pass "icgasl supports --version"
else
  fail "icgasl supports --version"
fi

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────
echo ""
summary
