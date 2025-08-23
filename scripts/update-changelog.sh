#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION="$1"
DATE=$(date +%Y-%m-%d)

echo "Updating CHANGELOG.md with version $VERSION..."

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

# Get commits since last tag
if [ ! -z "$LATEST_TAG" ]; then
    echo "Getting commits since $LATEST_TAG..."
    COMMITS=$(git log --oneline --pretty=format:"- %s" ${LATEST_TAG}..HEAD 2>/dev/null)
else
    echo "No previous tags found, getting all commits..."
    COMMITS=$(git log --oneline --pretty=format:"- %s")
fi

# Create a temporary file with the new changelog entry
TEMP_CHANGELOG=$(mktemp)

# Get everything up to and including the [Unreleased] section
sed -n '1,/^## \[Unreleased\]$/p' CHANGELOG.md > $TEMP_CHANGELOG

# Add empty line after [Unreleased]
echo "" >> $TEMP_CHANGELOG

# Add the new version entry
echo "## [$VERSION] - $DATE" >> $TEMP_CHANGELOG
echo "" >> $TEMP_CHANGELOG
if [ ! -z "$COMMITS" ]; then
    echo "$COMMITS" >> $TEMP_CHANGELOG
else
    echo "- Initial release" >> $TEMP_CHANGELOG
fi

# Add all existing version entries (skip the Unreleased section)
sed -n '/^## \[/,$p' CHANGELOG.md | grep -v "^## \[Unreleased\]" >> $TEMP_CHANGELOG

# Replace the original file
mv $TEMP_CHANGELOG CHANGELOG.md

echo "CHANGELOG.md updated successfully"