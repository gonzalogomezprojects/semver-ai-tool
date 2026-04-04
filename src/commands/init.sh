#!/usr/bin/env bash
set -e

CONFIG_FILE=".semver-ai.json"

if [ -f "$CONFIG_FILE" ]; then
    echo "⚠️  The project is already initialized ($CONFIG_FILE exists)."
    printf "Do you want to re-configure it? (y/n): "
    read overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""
echo "🚀 Initializing SemVer AI Tool configuration..."
echo "------------------------------------------------"

# 1. Collect Project Info (Name, Lang, Author, Docs Dir)
suggested_name=$(node -p "require('./package.json').name || ''" 2>/dev/null || echo "")
echo "Enter your project name [Current: $suggested_name]:"
printf "> "
read project_name
project_name=${project_name:-$suggested_name}

echo ""
echo "Preferred language for Release Notes? (es/en) [Default: es]:"
printf "> "
read release_lang
release_lang=${release_lang:-es}

suggested_author=$(node -p "require('./package.json').author || ''" 2>/dev/null || echo "")
echo ""
echo "Enter your Author Name (for release notes) [Current: $suggested_author]:"
printf "> "
read author_name
author_name=${author_name:-$suggested_author}

echo ""
echo "Directory to store release notes? [Default: docs/releases]:"
printf "> "
read docs_dir
docs_dir=${docs_dir:-docs/releases}

# 2. Ask explicitly for AI Integration
echo ""
echo "🧠 Do you want to integrate AI to generate professional release notes? (y/n):"
printf "> "
read want_ai

groq_api_key=""
groq_model="llama-3.3-70b-versatile"
DEFAULT_GROQ_URL="https://api.groq.com/openai/v1/chat/completions"

if [[ "$want_ai" =~ ^[Yy]$ ]]; then
    echo ""
    echo "💡 Please paste your Groq API Key (starts with gsk_):"
    printf "> "
    read groq_api_key
    if [ -z "$groq_api_key" ]; then
        echo "⚠️  No key provided. Continuing in Local Mode."
    else
        echo "✅ AI mode enabled using Groq API."
    fi
else
    echo "🏠 Continuing in Local Mode (No-AI required)."
fi

# 3. Create JSON Configuration
cat <<EOF > "$CONFIG_FILE"
{
  "project_name": "$project_name",
  "author_name": "$author_name",
  "release_language": "$release_lang",
  "docs_dir": "$docs_dir",
  "groq_api_key": "$groq_api_key",
  "groq_model": "$groq_model",
  "groq_url": "$DEFAULT_GROQ_URL",
  "tech_docs_url": "https://github.com/gonzalogomezprojects/semver-ai-tool/blob/main/docs/${release_lang}/technical-architecture.md"
}
EOF

# 4. Auto-update .gitignore for security
GITIGNORE=".gitignore"
if [ ! -f "$GITIGNORE" ]; then touch "$GITIGNORE"; fi

if ! grep -q "$CONFIG_FILE" "$GITIGNORE"; then
    echo "" >> "$GITIGNORE"
    echo "# SemVer AI Tool Configuration" >> "$GITIGNORE"
    echo "$CONFIG_FILE" >> "$GITIGNORE"
    git rm --cached "$CONFIG_FILE" > /dev/null 2>&1 || true
    echo "✅ Applied security: $CONFIG_FILE added to $GITIGNORE."
fi

echo ""
echo "✨ Configuration saved successfully at $CONFIG_FILE."
echo "   Author: $author_name"
echo "   Language: $release_lang"
echo "   Docs Dir: $docs_dir"
if [ -z "$groq_api_key" ]; then
    echo "   Mode: 🏠 Local (Notes without AI)"
else
    echo "   Mode: 🧠 AI-Powered (Professional notes)"
fi
echo ""
echo "You're all set! Run 'semver-ai release' and start versioning your project."
