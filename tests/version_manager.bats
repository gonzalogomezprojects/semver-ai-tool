#!/usr/bin/env bats
# Tests for version_manager.sh - SemVer calculation logic

setup() {
    # Set up test environment - source the script under test
    SCRIPT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    source "$SCRIPT_DIR/src/core/version_manager.sh"
}

@test "calculate_next_version: patch bump increments patch" {
    run calculate_next_version "1.0.0" "patch"
    [ "$status" -eq 0 ]
    [ "$output" = "1.0.1" ]
}

@test "calculate_next_version: minor bump increments minor and resets patch" {
    run calculate_next_version "1.0.0" "minor"
    [ "$status" -eq 0 ]
    [ "$output" = "1.1.0" ]
}

@test "calculate_next_version: major bump increments major and resets minor/patch" {
    run calculate_next_version "1.2.3" "major"
    [ "$status" -eq 0 ]
    [ "$output" = "2.0.0" ]
}

@test "calculate_next_version: handles v prefix" {
    run calculate_next_version "v1.2.3" "patch"
    [ "$status" -eq 0 ]
    [ "$output" = "1.2.4" ]
}

@test "calculate_next_version: invalid bump type returns unchanged" {
    run calculate_next_version "1.0.0" "invalid"
    [ "$status" -eq 0 ]
    [ "$output" = "1.0.0" ]
}

@test "calculate_next_version: handles missing components" {
    run calculate_next_version "1" "patch"
    [ "$status" -eq 0 ]
    [ "$output" = "1.0.1" ]
}

@test "calculate_next_version: zero initialization on malformed" {
    run calculate_next_version "abc" "patch"
    [ "$status" -eq 0 ]
    [ "$output" = "0.0.1" ]
}