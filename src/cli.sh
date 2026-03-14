#!/usr/bin/env bash
set -e

# CLI Entry Point
# Follows the Command Pattern by delegating duties to specific command scripts.

# Calculate the actual path where the script is installed (even if it's an npm symlink)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
export SEMVER_AI_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && cd .. && pwd )"

COMMAND="$1"
shift || true

show_help() {
    echo "Usage: semver-ai <command>"
    echo ""
    echo "Commands:"
    echo "  init      Initialize the project. Creates a .semver-ai.json configuration."
    echo "  release   Bump the version and use AI to generate release documentation."
    echo "  version   Show tool current version."
    echo "  help      Show this help interface."
}

VERSION=$(node -p "require('$SEMVER_AI_DIR/package.json').version")

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
