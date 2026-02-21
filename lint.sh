#!/usr/bin/env bash
set -euo pipefail

shellcheck sync icgasl lib.sh
echo "All scripts pass shellcheck."
