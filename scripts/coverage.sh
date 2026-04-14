#!/bin/bash

echo "Running tests with coverage..."
flutter test --coverage \
  --coverage-path=coverage/lcov.info \
  --coverage-package=ditonton \
  --coverage-package=core \
  --coverage-package=movies \
  --coverage-package=tv_series \
  --coverage-package=about

if ! command -v lcov &> /dev/null
then
    echo "lcov is not installed. Please install it:"
    echo "  macOS: brew install lcov"
    echo "  Linux: sudo apt-get install lcov"
    exit 1
fi

echo "Filtering coverage..."
lcov --remove coverage/lcov.info \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  '**/main.dart' \
  'test/**' \
  'integration_test/**' \
  '**/pub-cache/**' \
  '*.pub-cache*' \
  --ignore-errors unused,empty \
  -o coverage/lcov.info

lcov --extract coverage/lcov.info \
  '*/core/lib/*' \
  '*/movies/lib/*' \
  '*/tv_series/lib/*' \
  '*/about/lib/*' \
  '*/lib/*' \
  --ignore-errors unused,empty \
  -o coverage/lcov.info

echo "Generating HTML report..."
genhtml coverage/lcov.info \
  --ignore-errors empty \
  -o coverage/html

COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -o '[0-9]*\.[0-9]*%' | head -1 | tr -d '%')

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
