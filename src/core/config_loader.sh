# config_loader.sh
# Handles safe JSON parsing relying on JQ and env variable mounting

load_project_config() {
    local config_file=".semver-ai.json"
    local env_file=".semver-ai.env"

    if [ ! -f "$config_file" ]; then
        echo "Error: Project config ($config_file) not found in the current directory."
        echo "Run 'semver-ai init' to create one."
        exit 1
    fi

    # Extract everything from the local JSON securely using node
    export PROJECT_NAME=$(node -p "require('./' + '$config_file').project_name || 'unknown'")
    export PROJECT_DOCS_DIR=$(node -p "require('./' + '$config_file').docs_dir || 'docs/releases'")
    export AUTHOR_NAME=$(node -p "require('./' + '$config_file').author_name || 'unknown'")
    export RELEASE_LANGUAGE=$(node -p "require('./' + '$config_file').release_language || 'en'")

    # Model config from JSON (public)
    export GROQ_MODEL=$(node -p "require('./' + '$config_file').groq_model || 'llama-3.3-70b-versatile'")
    export GROQ_URL=$(node -p "require('./' + '$config_file').groq_url || 'https://api.groq.com/openai/v1/chat/completions'")

    # Credentials: Priority: 1) Env var (CI/CD) 2) .env file (local) 3) empty (local mode)
    if [ -n "$GROQ_API_KEY" ]; then
        # Already set in environment (CI/CD)
        echo "  -> Using API key from environment variable."
    elif [ -f "$env_file" ]; then
        # Load from .env file (local development)
        source "$env_file"
        echo "  -> Loaded API credentials from $env_file (mode: $(stat -c '%a' "$env_file" 2>/dev/null || echo 'unknown'))."
    else
        # No credentials - local mode
        echo "  -> No credentials found. Running in Local Mode (No AI)."
    fi

    if [ -z "$GROQ_API_KEY" ]; then
        echo "  -> Note: No Groq API Key found. Skipping AI features."
    fi
}

# load_credentials is now handled by load_project_config (reads .env)
load_credentials() {
    return 0
}
