#!/usr/bin/env bash
# Quick-sign the unsigned Serum iOS build so you can sideload it onto
# your iPhone.
#
# Requires:
#   - macOS with Xcode command-line tools installed
#   - An Apple signing identity in Keychain. A free "Personal Team"
#     identity (created by signing into Xcode with an Apple ID) works.
#
# List available identities:
#   security find-identity -v -p codesigning
#
# Usage:
#   ./sign_ios.sh "Apple Development: you@example.com (ABCDE12345)"
#
# Output: Serum.ipa in the current directory. Install via AltStore,
# Sideloadly, or `xcrun devicectl device install app`.
set -euo pipefail

IDENTITY="${1:-}"
if [ -z "$IDENTITY" ]; then
  cat <<'USAGE'
Usage: ./sign_ios.sh "<signing-identity>"

List available identities with:
  security find-identity -v -p codesigning

Example:
  ./sign_ios.sh "Apple Development: you@example.com (ABCDE12345)"
USAGE
  exit 1
fi

SRC_ZIP="serum-ios-unsigned.zip"
if [ ! -f "$SRC_ZIP" ]; then
  echo "error: $SRC_ZIP not found in $(pwd)"
  echo "Run this script from the cloned Serum-Downloads directory."
  exit 1
fi

if ! command -v codesign >/dev/null 2>&1; then
  echo "error: codesign not found. Install Xcode command-line tools:"
  echo "  xcode-select --install"
  exit 1
fi

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

echo "Unpacking..."
unzip -q "$SRC_ZIP" -d "$WORK"

APP="$WORK/Runner.app"
if [ ! -d "$APP" ]; then
  echo "error: Runner.app not found inside $SRC_ZIP"
  exit 1
fi

echo "Signing with: $IDENTITY"
# --deep recursively signs embedded frameworks and dylibs.
# --force overwrites any stale signatures left over from the CI build.
# --timestamp=none skips the Apple timestamp authority round-trip; fine
#   for a sideload build, don't use this flag for App Store submission.
codesign --force --deep --sign "$IDENTITY" --timestamp=none "$APP"

echo "Packaging .ipa..."
mkdir -p "$WORK/Payload"
mv "$APP" "$WORK/Payload/"
OUT="$(pwd)/Serum.ipa"
rm -f "$OUT"
(cd "$WORK" && zip -qr "$OUT" Payload)

echo
echo "Done: $OUT"
echo
echo "Install options:"
echo "  1. Drag onto AltStore or Sideloadly (they handle provisioning)."
echo "  2. xcrun devicectl device install app --device <uuid> \"$OUT\""
echo "  3. ideviceinstaller -i \"$OUT\"  (requires libimobiledevice)"
