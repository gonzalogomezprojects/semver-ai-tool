#!/usr/bin/env bash
set -e

CONFIG_FILE=".semver-ai.json"

if [ -f "$CONFIG_FILE" ]; then
    echo "Error: Project is already initialized ($CONFIG_FILE already exists)."
    exit 0
fi

echo "Initializing SemVer AI Tool configuration..."

# 1. Collect Project Info
echo "Enter your project name:"
printf "> "
read project_name

echo "Preferred language for AI Release Notes? (es/en):"
printf "> "
read release_lang

# Ensure default if empty
release_lang=${release_lang:-en}

echo "Enter your Author Name (for release notes):"
printf "> "
read author_name

# 2. Collect Credentials (Shadcn style - local)
echo "Please paste your Groq API Key (starts with gsk_):"
printf "> "
read groq_api_key

DEFAULT_GROQ_URL="https://api.groq.com/openai/v1/chat/completions"
echo "Using default Groq API Endpoint: $DEFAULT_GROQ_URL"

# JSON Configuration with credentials embedded
cat <<EOF > "$CONFIG_FILE"
{
  "project_name": "$project_name",
  "author_name": "$author_name",
  "release_language": "$release_lang",
  "docs_dir": "docs/releases",
  "groq_api_key": "$groq_api_key",
  "groq_model": "llama-3.3-70b-versatile",
  "groq_url": "$DEFAULT_GROQ_URL"
}
EOF

# 3. Auto-update .gitignore for security
GITIGNORE=".gitignore"
if [ ! -f "$GITIGNORE" ]; then
    touch "$GITIGNORE"
fi

if ! grep -q "$CONFIG_FILE" "$GITIGNORE"; then
    echo "" >> "$GITIGNORE"
    echo "# SemVer AI Tool Configuration (contains sensitive API Key)" >> "$GITIGNORE"
    echo "$CONFIG_FILE" >> "$GITIGNORE"
    echo "✅ Success: added $CONFIG_FILE to $GITIGNORE for security."
fi

echo "Done! Configuration saved at $CONFIG_FILE."
echo "CRITICAL: Do not remove $CONFIG_FILE from your .gitignore to keep your API Key safe."
echo "You can now run 'semver-ai release' after making commits."
