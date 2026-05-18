#!/usr/bin/env bash
set -e

source "$SEMVER_AI_DIR/src/core/config_loader.sh"
source "$SEMVER_AI_DIR/src/core/git_manager.sh"
source "$SEMVER_AI_DIR/src/core/styles.sh"

BUMP_TYPE="$1"

# Validate bump type
if [ -z "$BUMP_TYPE" ]; then
    echo "Usage: semver-ai bump <patch|minor|major>"
    echo ""
    echo "Examples:"
    echo "  semver-ai bump patch    # 1.0.0 → 1.0.1"
    echo "  semver-ai bump minor    # 1.0.0 → 1.1.0"
    echo "  semver-ai bump major    # 1.0.0 → 2.0.0"
    exit 1
fi

if [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
    print_error "Invalid bump type: $BUMP_TYPE"
    echo "Valid types: patch, minor, major"
    exit 1
fi

load_project_config

# Get current version
if [ ! -f "package.json" ]; then
    print_error "package.json not found in current directory"
    exit 1
fi

current_version=$(node -p "require('./package.json').version || '0.0.0'")

echo ""
echo "${MAGENTA}${BOLD}◈ Bumping Version${RESET}"
print_divider
echo ""

print_step "Current version" "$current_version"
print_step "Bump type" "$BUMP_TYPE"

# Check commits (optional detection)
last_tag=$(get_last_tag)
if [ -n "$last_tag" ]; then
    commits_since=$(get_commits_since_tag "$last_tag")
    detected=$(determine_bump_type "$commits_since")
    echo ""
    print_info "Detected from commits: $detected"
    echo ""
    read -p "Use detected type '$detected' instead of manual '$BUMP_TYPE'? [y/N]: " use_detected
    if [[ "$use_detected" =~ ^[Yy]$ ]]; then
        BUMP_TYPE="$detected"
    fi
fi

# Perform bump
echo ""
print_step "Bumping" "$BUMP_TYPE..."

next_version=$(npm version "$BUMP_TYPE" --no-git-tag-version --no-commit-hooks 2>/dev/null)
next_version="${next_version#v}"

print_success "Version bumped: $current_version → $next_version"

# Ask about git commit
echo ""
read -p "Commit version bump? [Y/n]: " do_commit
do_commit=${do_commit:-y}

if [[ "$do_commit" =~ ^[Yy]$ ]]; then
    git add package.json
    if [ -f "package-lock.json" ]; then
        git add package-lock.json
    fi
    git commit -m "chore(release): v${next_version} [skip ci]"
    print_success "Committed"
fi

# Ask about tag
echo ""
read -p "Create annotated tag? [Y/n]: " do_tag
do_tag=${do_tag:-y}

if [[ "$do_tag" =~ ^[Yy]$ ]]; then
    git tag -a "v${next_version}" -m "Release v${next_version}"
    print_success "Tagged v${next_version}"
fi

# Ask about push
echo ""
read -p "Push to remote? [y/N]: " do_push
if [[ "$do_push" =~ ^[Yy]$ ]]; then
    git push --follow-tags
    print_success "Pushed to remote"
fi

echo ""
print_divider
print_success "Done! Run 'semver-ai release' to generate documentation."
echo ""