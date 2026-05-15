#!/usr/bin/env bash
# Echo-only helper for GOAD-Smoke + extensions manual REPL checks (paste into `goad` console).
# Replace INSTANCE and adjust set_extensions list as needed.
set -euo pipefail
cat <<'EOF'
set_lab GOAD-Smoke
set_provider ludus
set_provisioning_method local
set_extensions smoke-ci
use INSTANCE
install
EOF
echo "# Replace INSTANCE with: goad -t list (or your workspace instance id)"
