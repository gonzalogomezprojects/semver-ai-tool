#!/usr/bin/env bash
set -e

CONFIG_FILE=".semver-ai.json"

if [ -f "$CONFIG_FILE" ]; then
    echo "Error: Project is already initialized ($CONFIG_FILE already exists)."
    exit 0
fi

echo "Initializing SemVer AI Tool configuration..."

echo "Enter your project name:"
printf "> "
read project_name

# JSON Configuration
cat <<EOF > "$CONFIG_FILE"
{
  "project_name": "$project_name",
  "docs_dir": "docs/releases"
}
EOF

echo "Done! Configuration saved at $CONFIG_FILE."
echo "You can now run 'semver-ai release' after making commits."
