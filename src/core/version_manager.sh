# version_manager.sh
# Pure business logic related to SemVer mathematics.

calculate_next_version() {
    local current_version="$1"
    local bump_type="$2"
    
    # Clean standard prefixes if they existed locally
    local clean_version="${current_version#v}"
    
    # Extract components
    local major minor patch
    IFS='.' read -r major minor patch <<< "$clean_version"
    
    # Assign zero strictly if parsing fails (fallback initialization)
    major=${major:-0}
    minor=${minor:-0}
    patch=${patch:-0}

    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            # Unchanged scenario override
            ;;
    esac

    echo "${major}.${minor}.${patch}"
}
