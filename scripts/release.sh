#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION="$1"
BRANCH_NAME="release/v$VERSION"

echo "Creating release branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

echo "Getting latest tag..."
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.1.0")
echo "Latest tag: $LATEST_TAG"

echo "Updating README.md version from $LATEST_TAG to $VERSION..."
sed -i '' "s/from: \"$LATEST_TAG\"/from: \"$VERSION\"/" README.md

echo "Updating CHANGELOG.md..."
./scripts/update-changelog.sh "$VERSION"

echo "Updating documentation..."
./scripts/update-docs.sh

echo "Committing version update and updated docs..."
git add .
git commit -m "Update version to v$VERSION and regenerate documentation"

echo "Release branch $BRANCH_NAME created with updated docs"