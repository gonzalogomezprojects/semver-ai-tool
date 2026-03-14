# config_loader.sh
# Handles safe JSON parsing relying on JQ and env variable mounting

load_project_config() {
    local config_file=".semver-ai.json"
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
    
    # Credentials (Also from JSON now)
    export GROQ_API_KEY=$(node -p "require('./' + '$config_file').groq_api_key || ''")
    export GROQ_MODEL=$(node -p "require('./' + '$config_file').groq_model || 'llama-3.3-70b-versatile'")
    export GROQ_URL=$(node -p "require('./' + '$config_file').groq_url || 'https://api.groq.com/openai/v1/chat/completions'")

    if [ -z "$GROQ_API_KEY" ]; then
        echo "Error: Missing groq_api_key in $config_file."
        exit 1
    fi
}

# load_credentials is now a no-op as everything is in the project config
load_credentials() {
    return 0
}
