#!/bin/bash

SOURCE_DIR="../history"
TARGET_DIR="_history"

# Remove existing files in target directory
rm -r "$TARGET_DIR"/*

# Create necessary subdirectories
mkdir -p "$TARGET_DIR/timelines" "$TARGET_DIR/tags" "$TARGET_DIR/sources"

# Copy files from source to target directories
cp "$SOURCE_DIR/timelines/"* "$TARGET_DIR/timelines/"
cp "$SOURCE_DIR/tags/"* "$TARGET_DIR/tags/"
cp "$SOURCE_DIR/sources/"* "$TARGET_DIR/sources/"

# Rename README.md to index.md
mv "$TARGET_DIR/timelines/README.md" "$TARGET_DIR/timelines/index.md"
mv "$TARGET_DIR/tags/README.md" "$TARGET_DIR/tags/index.md"
mv "$TARGET_DIR/sources/README.md" "$TARGET_DIR/sources/index.md"

# Add front matter if missing (EXCLUDING index.md files)
for file in "$TARGET_DIR"/**/*.md; do
    filename=$(basename "$file")
    if [[ "$filename" != "index.md" && ! $(head -n 1 "$file") =~ ^--- ]]; then
        echo "Adding frontmatter to $file"
        echo -e "---\nlayout: history\n---\n$(cat "$file")" > "$file"
    fi
done

# Updating links of format "../tags/fare-increases.md" to the format "../../tags/fare-increases"
echo "Updating internal links."
find "$TARGET_DIR/timelines/" -type f -name "*.md" -exec sed -i '' 's|\.\./tags/\([^ ]*\)\.md|../../tags/\1/|g' {} +
find "$TARGET_DIR/tags/" -type f -name "*.md" -exec sed -i '' 's|\.\./tags/\([^ ]*\)\.md|../../tags/\1/|g' {} +
find "$TARGET_DIR/sources/" -type f -name "*.md" -exec sed -i '' 's|\.\./tags/\([^ ]*\)\.md|../../tags/\1/|g' {} +

# Add front matter + permalinks for index.md files
echo "Adding frontmatter to directory indexes."
echo -e "---\nlayout: default\npermalink: /history/timelines/\n---\n$(cat "$TARGET_DIR/timelines/index.md")" > "$TARGET_DIR/timelines/index.md"
echo -e "---\nlayout: default\npermalink: /history/tags/\n---\n$(cat "$TARGET_DIR/tags/index.md")" > "$TARGET_DIR/tags/index.md"
echo -e "---\nlayout: default\npermalink: /history/sources/\n---\n$(cat "$TARGET_DIR/sources/index.md")" > "$TARGET_DIR/sources/index.md"

# Updating links of format "./fare-increases.md" to the format "./fare-increases/"
sed -i '' 's|\(\./[^ ]*\)\.md|\1/|g' "$TARGET_DIR/timelines/index.md"
sed -i '' 's|\(\./[^ ]*\)\.md|\1/|g' "$TARGET_DIR/tags/index.md"
sed -i '' 's|\(\./[^ ]*\)\.md|\1/|g' "$TARGET_DIR/sources/index.md"

echo "Processing complete!"
