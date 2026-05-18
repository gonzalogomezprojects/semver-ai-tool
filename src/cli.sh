#!/usr/bin/env bash
set -e

# CLI Entry Point
# Follows the Command Pattern by delegating duties to specific command scripts.

# Load styles for help output
source "$SEMVER_AI_DIR/src/core/styles.sh" 2>/dev/null || true

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
    # Detect language from config if exists, fallback to en
    local lang="en"
    if [ -f ".semver-ai.json" ]; then
        lang=$(node -p "require('./.semver-ai.json').release_language || 'en'")
    fi

    echo ""
    echo "${MAGENTA}${BOLD}◈ SemVer AI Tool v$VERSION${RESET}"
    echo "${DIM}Automate semantic versioning + AI-powered release notes${RESET}"
    echo ""

    if [ "$lang" = "es" ]; then
        print_divider
        echo ""
        print_arrow "init           Inicializar proyecto y configurar API"
        print_arrow "release        Analizar commits → bump → generar docs"
        print_arrow "bump           Bump manual sin generar docs"
        print_arrow "status         Ver estado actual (versión, próximo bump)"
        print_arrow "doctor         Diagnosticar problemas de configuración"
        print_arrow "config         Ver/editar configuración"
        print_arrow "guide          Guía de aprendizaje (semver, commits)"
        print_arrow "update         Instrucciones de actualización"
        echo ""
        print_divider
        echo ""
        echo "${CYAN}Guía de Commits (SemVer):${RESET}"
        print_bullet "fix: ...       → PATCH (v1.0.1) ${GRAY}correcciones${RESET}"
        print_bullet "feat: ...      → MINOR (v1.1.0) ${GRAY}nuevas features${RESET}"
        print_bullet "BREAKING ...   → MAJOR (v2.0.0) ${GRAY}cambios breaking${RESET}"
    else
        print_divider
        echo ""
        print_arrow "init           Initialize project and configure API"
        print_arrow "release        Analyze commits → bump → generate docs"
        print_arrow "bump           Manual bump without generating docs"
        print_arrow "status         Show current state (version, next bump)"
        print_arrow "doctor         Diagnose configuration issues"
        print_arrow "config         View/edit configuration"
        print_arrow "guide          Learning guide (semver, commits, workflow)"
        print_arrow "update         Update instructions"
        echo ""
        print_divider
        echo ""
        echo "${CYAN}Commit Guide (SemVer):${RESET}"
        print_bullet "fix: ...       → PATCH (v1.0.1) ${GRAY}bug fixes${RESET}"
        print_bullet "feat: ...      → MINOR (v1.1.0) ${GRAY}new features${RESET}"
        print_bullet "BREAKING ...   → MAJOR (v2.0.0) ${GRAY}breaking changes${RESET}"
    fi
    echo ""
    print_divider
    echo "${GRAY}Docs: ${WHITE}https://github.com/gonzalogomezprojects/semver-ai-tool${RESET}"
    echo ""
}

case "$COMMAND" in
    "--version"|"-v")
        echo "${MAGENTA}SemVer AI Tool${RESET} ${CYAN}v$VERSION${RESET}"
        exit 0
        ;;
    init)
        bash "$SEMVER_AI_DIR/src/commands/init.sh" "$@"
        ;;
    release)
        bash "$SEMVER_AI_DIR/src/commands/release.sh" "$@"
        ;;
    bump)
        bash "$SEMVER_AI_DIR/src/commands/bump.sh" "$@"
        ;;
    status)
        bash "$SEMVER_AI_DIR/src/commands/status.sh" "$@"
        ;;
    doctor)
        bash "$SEMVER_AI_DIR/src/commands/doctor.sh" "$@"
        ;;
    config)
        bash "$SEMVER_AI_DIR/src/commands/config.sh" "$@"
        ;;
    guide)
        bash "$SEMVER_AI_DIR/src/commands/guide.sh" "$@"
        ;;
    version)
        echo "${MAGENTA}SemVer AI Tool${RESET} ${CYAN}v$VERSION${RESET} ${GRAY}by Sarit Startup${RESET}"
        ;;
    update)
        echo ""
        echo "${MAGENTA}${BOLD}◈ Update Instructions${RESET}"
        print_divider
        echo ""
        print_arrow "Global install:"
        print_bullet "npm install -g github:gonzalogomezprojects/semver-ai-tool"
        echo ""
        print_arrow "npx (no install):"
        print_bullet "npx github:gonzalogomezprojects/semver-ai-tool <command>"
        echo ""
        print_arrow "Latest version:"
        print_bullet "https://github.com/gonzalogomezprojects/semver-ai-tool/releases"
        echo ""
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo "${RED}Unknown command: $COMMAND${RESET}"
        echo ""
        show_help
        exit 1
        ;;
esac
