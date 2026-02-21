#!/usr/bin/env bash
#
# test_helpers.sh - Shared test assertion functions
#
# Source this file in test scripts:
#   source "$(dirname "$0")/test_helpers.sh"

# Counters — use $((var + 1)) not ((var++)) for safety with set -e when var=0
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# TAP-compatible output
pass() {
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_PASSED=$((TESTS_PASSED + 1))
  echo "ok ${TESTS_RUN} - $1"
}

fail() {
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_FAILED=$((TESTS_FAILED + 1))
  echo "not ok ${TESTS_RUN} - $1"
  if [[ -n "${2:-}" ]]; then
    echo "#   $2"
  fi
}

# Assertions

assert_eq() {
  local description="$1"
  local expected="$2"
  local actual="$3"
  if [[ "$expected" == "$actual" ]]; then
    pass "$description"
  else
    fail "$description" "expected '${expected}', got '${actual}'"
  fi
}

assert_contains() {
  local description="$1"
  local haystack="$2"
  local needle="$3"
  if [[ "$haystack" == *"$needle"* ]]; then
    pass "$description"
  else
    fail "$description" "expected output to contain '${needle}'"
  fi
}

assert_not_contains() {
  local description="$1"
  local haystack="$2"
  local needle="$3"
  if [[ "$haystack" != *"$needle"* ]]; then
    pass "$description"
  else
    fail "$description" "expected output NOT to contain '${needle}'"
  fi
}

assert_file_exists() {
  local description="$1"
  local filepath="$2"
  if [[ -f "$filepath" ]]; then
    pass "$description"
  else
    fail "$description" "file not found: ${filepath}"
  fi
}

assert_dir_not_empty() {
  local description="$1"
  local dirpath="$2"
  if [[ -d "$dirpath" ]] && [[ -n "$(ls -A "$dirpath" 2>/dev/null)" ]]; then
    pass "$description"
  else
    fail "$description" "directory empty or missing: ${dirpath}"
  fi
}

assert_exit_zero() {
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$description"
  else
    fail "$description" "command exited non-zero: $*"
  fi
}

assert_exit_nonzero() {
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    fail "$description" "expected non-zero exit but got 0: $*"
  else
    pass "$description"
  fi
}

assert_gt() {
  local description="$1"
  local actual="$2"
  local threshold="$3"
  if [[ "$actual" -gt "$threshold" ]]; then
    pass "$description"
  else
    fail "$description" "expected > ${threshold}, got ${actual}"
  fi
}

# Print summary and return appropriate exit code
summary() {
  echo ""
  echo "# Tests: ${TESTS_RUN}, Passed: ${TESTS_PASSED}, Failed: ${TESTS_FAILED}"
  if [[ "$TESTS_FAILED" -gt 0 ]]; then
    return 1
  fi
  return 0
}
