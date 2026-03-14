# config_loader.sh
# Handles safe JSON parsing relying on JQ and env variable mounting

load_project_config() {
    local config_file=".semver-ai.json"
    if [ ! -f "$config_file" ]; then
        echo "Error: Project config ($config_file) not found in the current directory."
        echo "Run 'semver-ai init' to create one."
        exit 1
    fi
    
    # We parse the file using node securely
    export PROJECT_NAME=$(node -p "require('./' + '$config_file').project_name || 'unknown'")
    export PROJECT_DOCS_DIR=$(node -p "require('./' + '$config_file').docs_dir || 'docs/releases'")
}

load_credentials() {
    local cred_file="$HOME/.semver-ai/credentials.env"
    if [ ! -f "$cred_file" ]; then
        echo "Error: Global credentials not found at $cred_file."
        echo "Please create it with your GROQ_API_KEY."
        exit 1
    fi
    # Use allexport securely to pull env variables into current context session
    set -o allexport
    source "$cred_file"
    set +o allexport
}
