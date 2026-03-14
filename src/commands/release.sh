#!/usr/bin/env bash
set -e

# Core Release Orchestrator
# This orchestrator delegates work to small domain-focused core managers.

source "$SEMVER_AI_DIR/src/core/config_loader.sh"
source "$SEMVER_AI_DIR/src/core/git_manager.sh"
source "$SEMVER_AI_DIR/src/core/ai_client.sh"

echo "[1/4] Loading configurations..."
load_project_config
load_credentials

echo "[2/4] Analyzing repository state..."
commit_msg=$(get_last_commit_message)
bump_type=$(determine_bump_type "$commit_msg")

echo "  -> Last commit: \"$commit_msg\""
echo "  -> Detected change type: $bump_type"

if [ "$bump_type" = "none" ]; then
    echo "⚠️  No valid conventional commit (feat, fix, BREAKING CHANGE) detected."
    echo "Skipping release process."
    exit 0
fi

echo "[3/4] Bumping version..."
if [ ! -f "package.json" ]; then
    echo "Error: package.json not found in the current directory."
    exit 1
fi

current_version=$(node -p "require('./package.json').version || '0.0.0'")
# We use npm directly to increment the version, skipping git tag handling since we just want package.json updated
next_version=$(npm version $bump_type --no-git-tag-version --no-commit-hooks)
# Remove the 'v' prefix that npm version outputs
next_version="${next_version#v}"

echo "  -> $current_version  ==>  $next_version"

echo "[4/4] Generating AI Documentation..."
git_diff=$(get_commit_diff)
release_notes=$(generate_release_notes "$next_version" "$bump_type" "$commit_msg" "$git_diff")

# Save document
mkdir -p "$PROJECT_DOCS_DIR"
now=$(date +%Y%m%d_%H%M)
doc_file="$PROJECT_DOCS_DIR/release_v${next_version}_${now}.md"
echo "$release_notes" > "$doc_file"

echo ""
echo "🎉 Release successful! Release notes written to:"
echo "   $doc_file"
