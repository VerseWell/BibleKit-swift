#!/bin/sh

set -e

# Generate documentation for BibleKit Swift package
echo "Cleaning existing documentation..."
rm -rf ./docs
mkdir -p docs

echo "Generating documentation for BibleKit..."
swift package --disable-sandbox generate-documentation \
    --warnings-as-errors \
    --symbol-graph-minimum-access-level package \
    --enable-experimental-combined-documentation \
    --target BibleKit \
    --target BibleKitDB \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path BibleKit-swift

echo "Documentation generated successfully in ./docs"

INDEX_FILE="./docs/index.html"

# Create or overwrite the file with the redirect HTML
cat > "$INDEX_FILE" <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>BibleKit Documentation</title>
    <meta http-equiv="refresh" content="0; url=documentation/biblekit/" />
  </head>
  <body>
    <p>Redirecting to <a href="documentation/biblekit/">BibleKit Documentation</a>…</p>
  </body>
</html>
EOF

echo "✅ index.html has been written to $INDEX_FILE"
