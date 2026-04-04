# git_manager.sh
# Encapsulates all git CLI interactions.

get_last_tag() {
    # Get the latest tag, or fallback to the first commit if no tags exist
    git describe --tags --abbrev=0 2>/dev/null || echo ""
}

get_commits_since_tag() {
    local tag="$1"
    if [ -z "$tag" ]; then
        # No tag yet, get all commits
        git log --format="%s"
    else
        git log "$tag..HEAD" --format="%s"
    fi
}

get_diff_since_tag() {
    local tag="$1"
    if [ -z "$tag" ]; then
        # No tag yet, get all changes
        git diff $(git rev-list --max-parents=0 HEAD)..HEAD
    else
        git diff "$tag..HEAD"
    fi
}

determine_bump_type() {
    local messages="$1"
    local highest_bump="none"
    
    # Process each line of the messages
    while IFS= read -r line; do
        current_line_bump="none"
        
        # 1. Detection for Major (Breaking Changes)
        # Standards: 'feat!:', 'fix!:', or 'BREAKING CHANGE:' in body/footer
        if echo "$line" | grep -qiE "^(feat|fix|chore|docs|style|refactor|perf|test)(\(.*\))?!:" || echo "$line" | grep -q "BREAKING CHANGE:"; then
            current_line_bump="major"
        # 2. Detection for Minor (Features)
        elif echo "$line" | grep -qiE "^(feat|feature)(\(.*\))?:"; then
            current_line_bump="minor"
        # 3. Detection for Patch (Fixes and others)
        elif echo "$line" | grep -qiE "^(fix|chore|docs|style|refactor|perf|test)(\(.*\))?:"; then
            current_line_bump="patch"
        fi

        # Upgrade highest_bump if current_line_bump is higher priority
        if [ "$current_line_bump" = "major" ]; then
            highest_bump="major"
            break # Already at max, no need to check further
        elif [ "$current_line_bump" = "minor" ] && [ "$highest_bump" != "major" ]; then
            highest_bump="minor"
        elif [ "$current_line_bump" = "patch" ] && [ "$highest_bump" = "none" ]; then
            highest_bump="patch"
        fi
    done <<< "$messages"
    
    echo "$highest_bump"
}

