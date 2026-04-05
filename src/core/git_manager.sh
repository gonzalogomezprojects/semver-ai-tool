# git_manager.sh
# Encapsulates all git CLI interactions.

get_last_tag() {
    # Get the latest tag, or fallback to the first commit if no tags exist
    git describe --tags --abbrev=0 2>/dev/null || echo ""
}

get_commits_since_tag() {
    local tag="$1"
    if [ -z "$tag" ]; then
        # No tag yet, get all commits (Subject + Body)
        git log --format="%B"
    else
        git log "$tag..HEAD" --format="%B"
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
    
    # Process the entire messages (could be multi-line for a single commit)
    # We'll split by a delimiter or just grep the whole block for patterns
    # But let's keep it robust. A single commit with BREAKING CHANGE should trigger Major.
    
    # 1. Detection for Major (Breaking Changes)
    # Standards: Now focusing on 'BREAKING CHANGE:' in any part of the commit message (as requested)
    if echo "$messages" | grep -qiE "BREAKING[ -]CHANGE:"; then
        echo "major"
        return
    fi

    # Process each line for minor/patch (these usually come from the subject line)
    while IFS= read -r line; do
        current_line_bump="none"
        
        # 2. Detection for Minor (Features)
        if echo "$line" | grep -qiE "^(feat|feature)(\(.*\))?:"; then
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

