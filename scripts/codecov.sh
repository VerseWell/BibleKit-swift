#!/bin/sh

set -e

# Function to upload coverage report to Codecov
# Accepts token as first parameter
upload_coverage() {
    local token=$1
    local file_path=$2

    # Validate token parameter
    if [ -z "$token" ]; then
        echo "Error: Token parameter is required"
        echo "Usage: $0 <codecov-token>"
        exit 1
    fi

    # Check if file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: Coverage file does not exist: $file_path"
        exit 1
    fi

    # Calculate current git SHA
    local current_sha=$(git rev-parse HEAD)

    # Upload coverage report
    codecov upload-coverage \
        --file "$file_path" \
        -t "$token" \
        --git-service github \
        --sha "$current_sha"
}

echo "Running BibleKit tests with code coverage..."
swift test --enable-code-coverage

echo "Generating LCOV report from coverage data..."
xcrun llvm-cov export \
    .build/debug/BibleKitPackageTests.xctest/Contents/MacOS/BibleKitPackageTests \
    --format=lcov \
    --instr-profile .build/debug/codecov/default.profdata \
    > coverage.lcov

# Upload the generated LCOV file
upload_coverage "$1" coverage.lcov
