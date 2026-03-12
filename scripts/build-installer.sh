#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/AgentSkillsManager.xcodeproj"
SCHEME_NAME="AgentSkillsManager"
CONFIGURATION="Release"
DERIVED_DATA_PATH="$ROOT_DIR/.build/DerivedData"
DIST_DIR="$ROOT_DIR/dist"
APP_NAME="AgentSkillsManager"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/$APP_NAME.app"
PKG_PATH="$DIST_DIR/$APP_NAME.pkg"
ZIP_PATH="$DIST_DIR/$APP_NAME.zip"

mkdir -p "$DIST_DIR"

echo "Building $APP_NAME ($CONFIGURATION)..."
xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  build

if [[ ! -d "$APP_PATH" ]]; then
  echo "Built app not found: $APP_PATH" >&2
  exit 1
fi

rm -f "$PKG_PATH" "$ZIP_PATH"

echo "Packaging installer..."
pkgbuild \
  --component "$APP_PATH" \
  --install-location "/Applications" \
  "$PKG_PATH"

echo "Creating zip archive..."
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo ""
echo "Artifacts:"
echo "  PKG: $PKG_PATH"
echo "  ZIP: $ZIP_PATH"
