#!/usr/bin/env bash
set -e

source "$SEMVER_AI_DIR/src/core/config_loader.sh"
source "$SEMVER_AI_DIR/src/core/git_manager.sh"
source "$SEMVER_AI_DIR/src/core/styles.sh"

load_project_config

# Get current version from package.json
if [ -f "package.json" ]; then
    current_version=$(node -p "require('./package.json').version || '0.0.0'")
else
    current_version="0.0.0"
fi

# Get last tag
last_tag=$(get_last_tag)

# Get commit count since last tag
if [ -n "$last_tag" ]; then
    commit_count=$(git rev-list "$last_tag..HEAD" --count 2>/dev/null || echo "0")
    commits_since=$(get_commits_since_tag "$last_tag")
else
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    commits_since=$(get_commits_since_tag "")
fi

# Determine pending bump type
if [ -n "$commits_since" ]; then
    pending_bump=$(determine_bump_type "$commits_since")
else
    pending_bump="none"
fi

# Header
echo ""
echo "${MAGENTA}${BOLD}◈ SemVer AI Tool — Status${RESET}"
print_divider

# Project info
echo ""
print_keyval "Project" "$PROJECT_NAME"
print_keyval "Current" "v$current_version"

# Git status
echo ""
if [ -n "$last_tag" ]; then
    print_keyval "Last tag" "$last_tag"
    print_keyval "Commits" "$commit_count since $last_tag"
else
    print_keyval "Last tag" "${GRAY}none${RESET}"
    print_keyval "Commits" "total: $commit_count"
fi

# Pending bump
echo ""
if [ "$pending_bump" = "none" ]; then
    print_keyval "Next bump" "${GRAY}none (no conventional commits)${RESET}"
elif [ "$pending_bump" = "patch" ]; then
    print_keyval "Next bump" "${YELLOW}patch → v${current_version%.*.*}.$((${current_version##*.} + 1))${RESET}"
elif [ "$pending_bump" = "minor" ]; then
    print_keyval "Next bump" "${CYAN}minor → v${current_version%.*}.$((${current_version##*.} + 1)).0${RESET}"
elif [ "$pending_bump" = "major" ]; then
    print_keyval "Next bump" "${RED}major → v$((${current_version%%.*} + 1)).0.0${RESET}"
fi

# AI Mode
echo ""
if [ -n "$GROQ_API_KEY" ]; then
    print_keyval "AI Mode" "${GREEN}enabled${RESET} ($GROQ_MODEL)"
else
    print_keyval "AI Mode" "${GRAY}local (no API key)${RESET}"
fi

# Language
print_keyval "Language" "$RELEASE_LANGUAGE"

echo ""
print_divider
echo "${GRAY}Run ${WHITE}semver-ai release${GRAY} to bump version and generate docs${RESET}"
echo ""