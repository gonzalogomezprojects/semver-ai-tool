#!/usr/bin/env bash
set -e

# Core Release Orchestrator
# This orchestrator delegates work to small domain-focused core managers.

source "$SEMVER_AI_DIR/src/core/config_loader.sh"
source "$SEMVER_AI_DIR/src/core/git_manager.sh"
source "$SEMVER_AI_DIR/src/core/ai_client.sh"

echo "[1/4] Loading configurations..."
load_project_config

echo "[2/5] Analyzing repository state..."
# Priority: 1. Manual argument | 2. Auto-detection from multiple commits
manual_bump="$1"
last_tag=$(get_last_tag)

if [ -n "$last_tag" ]; then
    echo "  -> Last release tag: $last_tag"
    commit_history=$(get_commits_since_tag "$last_tag")
    git_diff=$(get_diff_since_tag "$last_tag")
else
    echo "  -> No previous tags found. Analyzing entire history..."
    commit_history=$(get_commits_since_tag "")
    git_diff=$(get_diff_since_tag "")
fi

if [ -n "$manual_bump" ] && [[ "$manual_bump" =~ ^(patch|minor|major)$ ]]; then
    bump_type="$manual_bump"
    echo "  -> Manual override detected: $bump_type"
else
    bump_type=$(determine_bump_type "$commit_history")
    echo "  -> Detected change type: $bump_type"
fi

if [ "$bump_type" = "none" ]; then
    echo "⚠️  No valid conventional commits (feat, fix, etc.) detected since $last_tag."
    echo "Skipping release process."
    exit 0
fi

echo "[3/5] Bumping version..."
if [ ! -f "package.json" ]; then
    echo "Error: package.json not found in the current directory."
    exit 1
fi

current_version=$(node -p "require('./package.json').version || '0.0.0'")
# Increment version in package.json
next_version=$(npm version $bump_type --no-git-tag-version --no-commit-hooks)
next_version="${next_version#v}"

echo "  -> $current_version  ==>  $next_version"

echo "[4/5] Generating AI Documentation..."
release_notes=$(generate_release_notes "$next_version" "$bump_type" "$commit_history" "$git_diff")

# Save document
mkdir -p "$PROJECT_DOCS_DIR"
now=$(date +"%d-%B-%Y_%H-%M")
doc_file="$PROJECT_DOCS_DIR/release_v${next_version}_${now}.md"
echo "$release_notes" > "$doc_file"
echo "  -> Release notes written to: $doc_file"

echo "[5/5] Persisting changes to Git..."
# Stage changes: package.json and the new release note
git add package.json
if [ -f "package-lock.json" ]; then git add package-lock.json; fi
git add "$doc_file"

git commit -m "chore(release): v${next_version} [skip ci]"
git tag -a "v${next_version}" -m "Release v${next_version}"

echo ""
echo "🎉 Release successful! Version $next_version is now committed and tagged."
echo "   Don't forget to run 'git push --follow-tags' to share the release."
