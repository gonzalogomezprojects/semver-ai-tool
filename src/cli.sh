#!/usr/bin/env bash
set -e

# CLI Entry Point
# Follows the Command Pattern by delegating duties to specific command scripts.

# Calculate the actual BASE path of the tool
# This logic is robust for both global npm installs and temporary npx runs
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do # check if it's a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR_OF_CLI_SH=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# The base dir is one level up from src/
export SEMVER_AI_DIR=$(cd "$DIR_OF_CLI_SH/.." && pwd)

# Get version safely without breaking on path formats
VERSION=$(node -e "console.log(require(require('path').join(process.env.SEMVER_AI_DIR, 'package.json')).version)")

COMMAND="$1"
shift || true

show_help() {
    echo "Usage: semver-ai <command>"
    echo ""
    echo "Commands:"
    echo "  init      Initialize the project. Creates a .semver-ai.json configuration."
    echo "  release   Bump the version and use AI to generate release documentation."
    echo "  help      Show this help interface."
}

case "$COMMAND" in
    "--version"|"-v")
        echo "SemVer AI Tool v$VERSION"
        exit 0
        ;;
    init)
        bash "$SEMVER_AI_DIR/src/commands/init.sh" "$@"
        ;;
    release)
        bash "$SEMVER_AI_DIR/src/commands/release.sh" "$@"
        ;;
    version)
        echo "SemVer AI Tool v1.0.0"
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;
esac
