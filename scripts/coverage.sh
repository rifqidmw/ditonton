#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LCOV_MERGED="$ROOT_DIR/coverage/lcov.info"

if ! command -v lcov &> /dev/null; then
    echo "lcov is not installed. Please install it:"
    echo "  macOS: brew install lcov"
    echo "  Linux: sudo apt-get install lcov"
    exit 1
fi

mkdir -p "$ROOT_DIR/coverage"
rm -f "$LCOV_MERGED"

MODULES=("core" "movies" "tv_series" "about")

for MODULE in "${MODULES[@]}"; do
    MODULE_DIR="$ROOT_DIR/$MODULE"
    if [ ! -d "$MODULE_DIR/test" ]; then
        echo "No test directory in $MODULE — skipping"
        continue
    fi

    echo "Running tests with coverage for module: $MODULE..."
    (cd "$MODULE_DIR" && flutter test --coverage --coverage-path=coverage/lcov.info) || true

    MODULE_LCOV="$MODULE_DIR/coverage/lcov.info"
    if [ ! -f "$MODULE_LCOV" ]; then
        echo "  No coverage output for $MODULE — skipping"
        continue
    fi

    sed "s|^SF:lib/|SF:$MODULE/lib/|g" "$MODULE_LCOV" >> "$LCOV_MERGED"
done

if [ ! -s "$LCOV_MERGED" ]; then
    echo "ERROR: No coverage data collected."
    exit 1
fi

echo "Filtering coverage..."
lcov --remove "$LCOV_MERGED" \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  'test/**' \
  --ignore-errors unused,empty \
  -o "$LCOV_MERGED"

echo "Generating HTML report..."
genhtml "$LCOV_MERGED" \
  --ignore-errors empty \
  -o "$ROOT_DIR/coverage/html"

COVERAGE=$(lcov --summary "$LCOV_MERGED" 2>&1 | grep "lines" | grep -o '[0-9]*\.[0-9]*%' | head -1 | tr -d '%')

echo ""
echo "======================================"
echo "Coverage: ${COVERAGE}%"
echo "Minimum required: 95%"
echo "======================================"
echo ""
echo "Coverage report generated at: coverage/html/index.html"
echo "Open with: open coverage/html/index.html (macOS) or xdg-open coverage/html/index.html (Linux)"

if [ -z "$COVERAGE" ]; then
    echo ""
    echo "⚠️  WARNING: Could not determine coverage percentage!"
    exit 1
elif (( $(echo "$COVERAGE < 95" | bc -l) )); then
    echo ""
    echo "⚠️  WARNING: Coverage is below 95% threshold!"
    exit 1
else
    echo ""
    echo "✅ Coverage meets the 95% threshold!"
    exit 0
fi
