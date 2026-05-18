#!/usr/bin/env bash
set -e

source "$SEMVER_AI_DIR/src/core/config_loader.sh"
source "$SEMVER_AI_DIR/src/core/styles.sh"

ACTION="$1"

show_config() {
    load_project_config

    echo ""
    echo "${MAGENTA}${BOLD}◈ SemVer AI Tool — Configuration${RESET}"
    print_divider
    echo ""

    print_keyval "Project" "$PROJECT_NAME"
    print_keyval "Author" "$AUTHOR_NAME"
    print_keyval "Language" "$RELEASE_LANGUAGE"
    print_keyval "Docs Dir" "$PROJECT_DOCS_DIR"

    echo ""
    print_keyval "Groq Model" "$GROQ_MODEL"
    print_keyval "Groq URL" "$GROQ_URL"

    echo ""
    if [ -n "$GROQ_API_KEY" ]; then
        # Show masked key
        masked="${GROQ_API_KEY:0:4}...${GROQ_API_KEY: -4}"
        print_keyval "API Key" "${GREEN}$masked${RESET}"
    else
        print_keyval "API Key" "${GRAY}not configured (local mode)${RESET}"
    fi

    echo ""
    print_divider
}

set_config() {
    local key="$1"
    local value="$2"

    if [ -z "$key" ] || [ -z "$value" ]; then
        print_error "Usage: semver-ai config set <key> <value>"
        exit 1
    fi

    if [ ! -f ".semver-ai.json" ]; then
        print_error "No config file found. Run 'semver-ai init' first."
        exit 1
    fi

    # Update JSON using node
    node -e "
        const fs = require('fs');
        const config = require('./.semver-ai.json');
        config['$key'] = '$value';
        fs.writeFileSync('.semver-ai.json', JSON.stringify(config, null, 2));
    "

    print_success "Updated $key = $value"
}

get_config() {
    local key="$1"

    if [ -z "$key" ]; then
        print_error "Usage: semver-ai config get <key>"
        exit 1
    fi

    if [ ! -f ".semver-ai.json" ]; then
        print_error "No config file found. Run 'semver-ai init' first."
        exit 1
    fi

    value=$(node -p "require('./.semver-ai.json').$key || 'not set'" 2>/dev/null)
    echo "$value"
}

case "$ACTION" in
    "")
        show_config
        ;;
    "get")
        get_config "$2"
        ;;
    "set")
        set_config "$2" "$3"
        ;;
    *)
        echo "Usage: semver-ai config [get <key> | set <key> <value>]"
        echo ""
        echo "Examples:"
        echo "  semver-ai config              # show all config"
        echo "  semver-ai config get release_language"
        echo "  semver-ai config set release_language es"
        exit 1
        ;;
esac