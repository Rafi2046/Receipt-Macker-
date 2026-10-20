#!/usr/bin/env bash
# Regenerates all generated code: localizations, freezed, json, riverpod, drift.
set -euo pipefail
cd "$(dirname "$0")/.."

flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

# After a schema change (bump schemaVersion first): snapshots the schema and
# regenerates migration steps and tests. Safe to run when nothing changed.
dart run drift_dev make-migrations
