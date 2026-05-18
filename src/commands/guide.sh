#!/usr/bin/env bash

source "$SEMVER_AI_DIR/src/core/styles.sh"

TOPIC="$1"

show_overview() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ SemVer AI Tool — Guide${RESET}"
    print_divider
    echo ""

    print_arrow "semver      → SemVer rules and version numbering"
    print_arrow "commits     → Conventional commits format"
    print_arrow "workflow   → How to use the CLI in your project"
    print_arrow "ai          → How AI generates release notes"
    print_arrow "security    → API keys and security best practices"
    print_arrow "ci          → GitHub Actions / GitLab CI integration"

    echo ""
    print_divider
    echo "${GRAY}Run: semver-ai guide <topic>${RESET}"
    echo ""
}

show_semver() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ Semantic Versioning Guide${RESET}"
    print_divider
    echo ""

    echo "${CYAN}Format: ${WHITE}MAJOR.MINOR.PATCH${RESET}"
    echo ""

    print_keyval "MAJOR" "${RED}Breaking changes${RESET}"
    print_bullet "Incompatible API changes"
    print_bullet "Removed features"
    print_bullet "Schema changes"

    echo ""
    print_keyval "MINOR" "${CYAN}New features${RESET}"
    print_bullet "Backward-compatible new functionality"
    print_bullet "Deprecated features (but still work)"
    print_bullet "Public API additions"

    echo ""
    print_keyval "PATCH" "${YELLOW}Bug fixes${RESET}"
    print_bullet "Backward-compatible bug fixes"
    print_bullet "Internal refactors"
    print_bullet "Performance improvements"

    echo ""
    print_divider
    echo "${GRAY}Examples:${RESET}"
    echo "  1.0.0 → 1.0.1  (patch: bug fix)"
    echo "  1.0.1 → 1.1.0  (minor: new feature)"
    echo "  1.1.0 → 2.0.0  (major: breaking change)"
    echo ""
}

show_commits() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ Conventional Commits Guide${RESET}"
    print_divider
    echo ""

    echo "${CYAN}Format:${RESET}"
    echo "  ${WHITE}<type>[(scope)]: <description>${RESET}"
    echo ""

    print_keyval "feat" "${CYAN}New feature${RESET} → MINOR bump"
    print_bullet "feat(auth): add OAuth login"
    print_bullet "feat: implement dark mode"

    echo ""
    print_keyval "fix" "${YELLOW}Bug fix${RESET} → PATCH bump"
    print_bullet "fix(api): resolve null pointer"
    print_bullet "fix: memory leak in handler"

    echo ""
    print_keyval "docs" "${GRAY}Documentation${RESET} → PATCH bump"
    print_bullet "docs: update README"
    print_bullet "docs(api): add endpoint examples"

    echo ""
    print_keyval "style" "${GRAY}Formatting${RESET} → PATCH bump"
    print_bullet "style: format code with prettier"
    print_bullet "style(css): adjust spacing"

    echo ""
    print_keyval "refactor" "${GRAY}Refactoring${RESET} → PATCH bump"
    print_bullet "refactor: simplify logic"
    print_bullet "refactor(api): extract to service"

    echo ""
    print_keyval "perf" "${GRAY}Performance${RESET} → PATCH bump"
    print_bullet "perf: optimize database query"

    echo ""
    print_keyval "test" "${GRAY}Testing${RESET} → PATCH bump"
    print_bullet "test: add unit tests"
    print_bullet "test(api): mock external service"

    echo ""
    print_keyval "chore" "${GRAY}Maintenance${RESET} → PATCH bump"
    print_bullet "chore: update dependencies"
    print_bullet "chore: bump version"

    echo ""
    print_divider
    echo "${CYAN}Breaking Changes:${RESET}"
    print_bullet "Add ${WHITE}BREAKING CHANGE:${RESET} in commit body"
    print_bullet "Or use ${WHITE}!${RESET} after type: ${WHITE}feat!: change API${RESET}"
    print_bullet "Both trigger MAJOR bump"
    echo ""

    echo "${GRAY}Example with breaking change:${RESET}"
    echo "${GRAY}  $ git commit -m \"feat(api): new endpoint${RESET}"
    echo "${GRAY}  >${RESET}"
    echo "${GRAY}  > BREAKING CHANGE: old v1 API is now deprecated\"${RESET}"
    echo ""
}

show_workflow() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ Workflow Guide${RESET}"
    print_divider
    echo ""

    print_step "1" "Initialize project"
    print_bullet "semver-ai init"
    print_bullet "Configure project name, author, language"
    print_bullet "Add Groq API key (optional)"

    echo ""
    print_step "2" "Make changes"
    print_bullet "Write code following conventional commits"
    print_bullet "Commit with: feat:, fix:, docs:, etc."

    echo ""
    print_step "3" "Check status"
    print_bullet "semver-ai status"
    print_bullet "See current version and pending bump type"

    echo ""
    print_step "4" "Run release"
    print_bullet "semver-ai release"
    print_bullet "Auto-detects bump type from commits"
    print_bullet "Bumps version in package.json"
    print_bullet "Generates AI-powered release notes"
    print_bullet "Commits and tags"

    echo ""
    print_divider
    echo "${GRAY}Alternative: Manual bump${RESET}"
    print_bullet "semver-ai bump patch    # just bump, no docs"
    print_bullet "semver-ai bump minor    # minor without AI"
    print_bullet "semver-ai bump major    # major without AI"
    echo ""
}

show_ai() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ AI Release Notes Guide${RESET}"
    print_divider
    echo ""

    echo "${CYAN}How it works:${RESET}"
    print_bullet "Tool reads all commits since last tag"
    print_bullet "Tool gets full git diff"
    print_bullet "Sends to Groq LLaMA 3.3 API"
    print_bullet "AI generates professional release notes"

    echo ""
    echo "${CYAN}Output format:${RESET}"
    print_bullet "Executive Summary"
    print_bullet "Key Highlights"
    print_bullet "Detailed Technical Changes"

    echo ""
    print_divider
    echo "${GRAY}No AI mode:${RESET}"
    print_bullet "If no API key → generates basic notes"
    print_bullet "Still works but without AI analysis"
    echo ""

    echo "${GRAY}Supported languages:${RESET}"
    print_bullet "English (en) - default"
    print_bullet "Spanish (es) - configured in init"
    echo ""
}

show_security() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ Security Guide${RESET}"
    print_divider
    echo ""

    print_keyval ".semver-ai.json" "Public config (safe to commit)"
    print_bullet "project_name, author, language"
    print_bullet "groq_model, groq_url"
    print_bullet "NO API keys here!"

    echo ""
    print_keyval ".semver-ai.env" "Private credentials (NEVER commit)"
    print_bullet "GROQ_API_KEY"
    print_bullet "Created with chmod 600 (owner only)"
    print_bullet "Automatically added to .gitignore"

    echo ""
    print_keyval "CI/CD" "Environment variables"
    print_bullet "Set GROQ_API_KEY in GitHub secrets"
    print_bullet "Pass as environment variable in workflow"
    print_bullet "Tool auto-detects CI environment"

    echo ""
    print_divider
    echo "${GREEN}✅ Best practices:${RESET}"
    print_bullet "Never commit .semver-ai.env"
    print_bullet "Use .semver-ai.env.example for reference"
    print_bullet "Rotate API keys periodically"
    print_bullet "Use least-privilege for CI secrets"
    echo ""
}

show_ci() {
    echo ""
    echo "${MAGENTA}${BOLD}◈ CI/CD Integration Guide${RESET}"
    print_divider
    echo ""

    echo "${CYAN}GitHub Actions Example:${RESET}"
    cat <<'EOF'
  jobs:
    release:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/setup-node@v4
          with:
            node-version: '20'

        - name: Install dependencies
          run: npm ci

        - name: Run SemVer AI Release
          env:
            GROQ_API_KEY: ${{ secrets.GROQ_API_KEY }}
          run: npx semver-ai release
EOF

    echo ""
    echo "${CYAN}GitLab CI Example:${RESET}"
    cat <<'EOF'
  release:
    image: node:20
    variables:
      GROQ_API_KEY: $GROQ_API_KEY_SECRET
    script:
      - npm ci
      - npx semver-ai release
    only:
      - main
EOF

    echo ""
    print_divider
    echo "${GRAY}Setup secrets:${RESET}"
    print_bullet "GitHub: Settings → Secrets → Actions → New"
    print_bullet "GitLab: Settings → CI/CD → Variables"
    echo ""
}

# Main
case "$TOPIC" in
    ""|help)
        show_overview
        ;;
    semver)
        show_semver
        ;;
    commits)
        show_commits
        ;;
    workflow)
        show_workflow
        ;;
    ai)
        show_ai
        ;;
    security)
        show_security
        ;;
    ci)
        show_ci
        ;;
    *)
        echo "${RED}Unknown topic: $TOPIC${RESET}"
        echo ""
        show_overview
        exit 1
        ;;
esac