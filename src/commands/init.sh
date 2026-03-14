#!/usr/bin/env bash
set -e

CONFIG_FILE=".semver-ai.json"

if [ -f "$CONFIG_FILE" ]; then
    echo "Error: Project is already initialized ($CONFIG_FILE already exists)."
    exit 0
fi

echo "Initializing SemVer AI Tool configuration..."

# -------------------------------------------------------------
# GLOBAL CREDENTIALS AUTO-SETUP (Shadcn-like magic)
# -------------------------------------------------------------
CRED_DIR="$HOME/.semver-ai"
CRED_FILE="$CRED_DIR/credentials.env"

if [ ! -f "$CRED_FILE" ]; then
    echo ""
    echo "✨ Welcome to SemVer AI Tool!"
    echo "It looks like this is your first time using the tool."
    echo "Let's set up your AI credentials securely. This will only happen once."
    echo ""
    
    echo "Please paste your Groq API Key (starts with gsk_):"
    printf "> "
    read groq_api_key
    
    echo "What is your Author Name? (This will be used in release notes):"
    printf "> "
    read author_name

    mkdir -p "$CRED_DIR"
    
    cat <<ENV_EOF > "$CRED_FILE"
GROQ_API_KEY="$groq_api_key"
GROQ_MODEL="llama-3.3-70b-versatile"
GROQ_URL="https://api.groq.com/openai/v1/chat/completions"

AUTHOR_NAME="$author_name"
ENV_EOF

    echo "✅ Success! Your global credentials have been securely saved at: $CRED_FILE"
    echo ""
fi
# -------------------------------------------------------------

echo "Let's configure your local project."
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
