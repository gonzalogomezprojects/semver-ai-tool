# git_manager.sh
# Encapsulates all git CLI interactions.

get_last_commit_message() {
    git log -1 --format="%s" || echo ""
}

get_commit_diff() {
    # Extract only the patch differences of the single latest commit
    git show HEAD --patch || echo ""
}

determine_bump_type() {
    local message="$1"
    
    # Strictly follow semantic versioning rules mapping
    if echo "$message" | grep -q "BREAKING CHANGE:"; then
        echo "major"
    elif echo "$message" | grep -qiE "^(feat|feature)(\(.*\))?!?:"; then
        echo "minor"
    elif echo "$message" | grep -qiE "^(fix|chore|docs|style|refactor|perf|test)(\(.*\))?:"; then
        echo "patch"
    else
        echo "none"
    fi
}
