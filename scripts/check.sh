#!/usr/bin/env bash
# Local CI: codegen, format check, analyze, tests. Must pass before every commit.
set -euo pipefail
cd "$(dirname "$0")/.."

step() { printf '\n\033[1m== %s\033[0m\n' "$1"; }

step "Codegen"
./scripts/gen.sh

step "Format"
find lib test -name '*.dart' \
  ! -name '*.g.dart' ! -name '*.freezed.dart' ! -path 'lib/l10n/gen/*' ! -path '*/migrations/*/generated/*' ! -name '*.steps.dart' -print0 \
  | xargs -0 dart format --output=none --set-exit-if-changed

step "Analyze"
flutter analyze

step "Test"
flutter test

printf '\n\033[32mAll checks passed.\033[0m\n'
