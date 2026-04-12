#!/bin/bash

echo "Running tests with coverage..."
flutter test --coverage --coverage-path=coverage/lcov.info

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
  -o coverage/lcov.info

echo "Generating HTML report..."
genhtml coverage/lcov.info -o coverage/html

COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | cut -d ' ' -f 4 | cut -d '%' -f 1)

echo ""
echo "======================================"
echo "Coverage: ${COVERAGE}%"
echo "Minimum required: 70%"
echo "======================================"
echo ""
echo "Coverage report generated at: coverage/html/index.html"
echo "Open with: open coverage/html/index.html (macOS) or xdg-open coverage/html/index.html (Linux)"

if (( $(echo "$COVERAGE < 70" | bc -l) )); then
    echo ""
    echo "⚠️  WARNING: Coverage is below 70% threshold!"
    exit 1
else
    echo ""
    echo "✅ Coverage meets the 70% threshold!"
    exit 0
fi
