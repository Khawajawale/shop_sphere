#!/usr/bin/env bash
# ShopSphere release build script (macOS / Linux)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Running tests..."
flutter test

echo "==> Building Android App Bundle (release)..."
flutter build appbundle --release

echo "==> Building Android APK (release)..."
flutter build apk --release

echo ""
echo "Build complete!"
echo "  AAB: build/app/outputs/bundle/release/app-release.aab"
echo "  APK: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "For iOS (requires macOS + Xcode):"
echo "  flutter build ipa --release"
