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
    # Detect language from config if exists, fallback to en
    local lang="en"
    if [ -f ".semver-ai.json" ]; then
        lang=$(node -p "require('./.semver-ai.json').release_language || 'en'")
    fi

    if [ "$lang" = "es" ]; then
        echo "🚀 SemVer AI Tool v$VERSION"
        echo "Automatiza el versionado semántico y genera notas de lanzamiento profesionales con IA."
        echo ""
        echo "USO:"
        echo "  semver-ai <comando> [opciones]"
        echo ""
        echo "COMANDOS:"
        echo "  init              Inicializa el proyecto y configura la API Key de Groq."
        echo "  release           Analiza commits, sube la versión y genera documentación."
        echo "  help              Muestra esta interfaz de ayuda detallada."
        echo ""
        echo "GUÍA DE COMMITS (SemVer):"
        echo "  fix: ...          Incrementa PATCH (v1.0.1) -> Correcciones internas."
        echo "  feat: ...         Incrementa MINOR (v1.1.0) -> Nuevas funcionalidades."
        echo "  BREAKING CHANGE:  Incrementa MAJOR (v2.0.0) -> Cambios incompatibles."
        echo ""
        echo "TIP PARA BASH/ZSH:"
        echo "  Si usas 'feat!: ...', envuélvelo en comillas simples para evitar errores:"
        echo "  git commit -m 'feat!: mi cambio radical'"
    else
        echo "🚀 SemVer AI Tool v$VERSION"
        echo "Automate semantic versioning and generate professional AI release notes."
        echo ""
        echo "USAGE:"
        echo "  semver-ai <command> [options]"
        echo ""
        echo "COMMANDS:"
        echo "  init              Initialize project and configure Groq API Key."
        echo "  release           Analyze commits, bump version, and generate documentation."
        echo "  help              Show this detailed help interface."
        echo ""
        echo "COMMIT GUIDE (SemVer):"
        echo "  fix: ...          Bumps PATCH (v1.0.1) -> Internal fixes."
        echo "  feat: ...         Bumps MINOR (v1.1.0) -> New features."
        echo "  BREAKING CHANGE:  Bumps MAJOR (v2.0.0) -> Incompatible changes."
        echo ""
        echo "BASH/ZSH TIP:"
        echo "  When using 'feat!: ...', wrap it in single quotes to avoid shell errors:"
        echo "  git commit -m 'feat!: radical change'"
    fi
    echo ""
    echo "Documentation: https://github.com/gonzalogomezprojects/semver-ai-tool"
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
        echo "SemVer AI Tool v$VERSION (by Sarit Startup)"
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
