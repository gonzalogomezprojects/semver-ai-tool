#!/usr/bin/env bats
# Tests for git_manager.sh - bump type detection

setup() {
    # Set up test environment - source the script under test
    SCRIPT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    source "$SCRIPT_DIR/src/core/git_manager.sh"
}

@test "determine_bump_type: feat triggers minor" {
    run determine_bump_type "feat: add new feature"
    [ "$status" -eq 0 ]
    [ "$output" = "minor" ]
}

@test "determine_bump_type: feature triggers minor" {
    run determine_bump_type "feature: add login"
    [ "$status" -eq 0 ]
    [ "$output" = "minor" ]
}

@test "determine_bump_type: fix triggers patch" {
    run determine_bump_type "fix: resolve bug"
    [ "$status" -eq 0 ]
    [ "$output" = "patch" ]
}

@test "determine_bump_type: chore triggers patch" {
    run determine_bump_type "chore: update dependencies"
    [ "$status" -eq 0 ]
    [ "$output" = "patch" ]
}

@test "determine_bump_type: docs triggers patch" {
    run determine_bump_type "docs: update readme"
    [ "$status" -eq 0 ]
    [ "$output" = "patch" ]
}

@test "determine_bump_type: BREAKING CHANGE triggers major" {
    run determine_bump_type "feat: add new API

BREAKING CHANGE: the API has changed"
    [ "$status" -eq 0 ]
    [ "$output" = "major" ]
}

@test "determine_bump_type: BREAKING CHANGE in commit body triggers major" {
    run determine_bump_type "fix: bug fix

BREAKING CHANGE: this breaks backward compatibility"
    [ "$status" -eq 0 ]
    [ "$output" = "major" ]
}

@test "determine_bump_type: multiple commits - feat wins over fix" {
    run determine_bump_type "feat: add feature
fix: resolve bug"
    [ "$status" -eq 0 ]
    [ "$output" = "minor" ]
}

@test "determine_bump_type: no conventional commits returns none" {
    run determine_bump_type "random message without convention"
    [ "$status" -eq 0 ]
    [ "$output" = "none" ]
}

@test "determine_bump_type: feat with scope triggers minor" {
    run determine_bump_type "feat(auth): add OAuth login"
    [ "$status" -eq 0 ]
    [ "$output" = "minor" ]
}

@test "determine_bump_type: fix with scope triggers patch" {
    run determine_bump_type "fix(api): resolve null pointer"
    [ "$status" -eq 0 ]
    [ "$output" = "patch" ]
}