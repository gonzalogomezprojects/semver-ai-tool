#!/usr/bin/env bash
set -e

source "$SEMVER_AI_DIR/src/core/styles.sh"

echo ""
echo "${MAGENTA}${BOLD}◈ SemVer AI Tool — Doctor${RESET}"
print_divider
echo ""

checks_passed=0
checks_failed=0

# Check: Node.js
if command -v node &> /dev/null; then
    node_version=$(node --version)
    print_success "Node.js: $node_version"
    ((checks_passed++))
else
    print_error "Node.js: not found (required)"
    ((checks_failed++))
fi

# Check: npm
if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    print_success "npm: v$npm_version"
    ((checks_passed++))
else
    print_error "npm: not found (required)"
    ((checks_failed++))
fi

# Check: Git
if command -v git &> /dev/null; then
    git_version=$(git --version | head -n1)
    print_success "Git: $git_version"
    ((checks_passed++))
else
    print_error "Git: not found (required)"
    ((checks_failed++))
fi

echo ""

# Check: package.json
if [ -f "package.json" ]; then
    print_success "package.json: exists"
    ((checks_passed++))
else
    print_error "package.json: not found in current directory"
    ((checks_failed++))
fi

# Check: .semver-ai.json
if [ -f ".semver-ai.json" ]; then
    print_success ".semver-ai.json: exists"
    ((checks_passed++))

    # Validate JSON syntax
    if node -e "require('./.semver-ai.json')" 2>/dev/null; then
        print_success ".semver-ai.json: valid JSON"
        ((checks_passed++))
    else
        print_error ".semver-ai.json: invalid JSON syntax"
        ((checks_failed++))
    fi
else
    print_error ".semver-ai.json: not found (run 'semver-ai init')"
    ((checks_failed++))
fi

echo ""

# Check: .semver-ai.env
if [ -f ".semver-ai.env" ]; then
    # Check permissions (Linux/Mac only)
    if [ "$(uname)" != "Windows_NT" ]; then
        perms=$(stat -c '%a' ".semver-ai.env" 2>/dev/null || echo "unknown")
        if [ "$perms" = "600" ]; then
            print_success ".semver-ai.env: exists (secure permissions: $perms)"
            ((checks_passed++))
        else
            print_warning ".semver-ai.env: exists but permissions are $perms (should be 600)"
            ((checks_failed++))
        fi
    else
        print_success ".semver-ai.env: exists"
        ((checks_passed++))
    fi

    # Check if has API key
    if grep -q "GROQ_API_KEY" ".semver-ai.env" && ! grep -q "GROQ_API_KEY=$" ".semver-ai.env"; then
        print_success ".semver-ai.env: API key configured"
        ((checks_passed++))
    else
        print_warning ".semver-ai.env: no API key (AI features disabled)"
    fi
else
    print_warning ".semver-ai.env: not found (optional - AI features disabled)"
fi

echo ""

# Check: .gitignore
if [ -f ".gitignore" ]; then
    if grep -q "\.semver-ai" ".gitignore"; then
        print_success ".gitignore: protects config files"
        ((checks_passed++))
    else
        print_warning ".gitignore: does not protect .semver-ai files"
    fi
fi

# Check: Git remote
remote=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$remote" ]; then
    print_success "Git remote: $remote"
    ((checks_passed++))
else
    print_warning "Git remote: not configured"
fi

echo ""
print_divider

# Summary
total_checks=$((checks_passed + checks_failed))
echo ""
if [ $checks_failed -eq 0 ]; then
    echo "${GREEN}${BOLD}All checks passed! ✓${RESET} ($checks_passed/$total_checks)"
else
    echo "${YELLOW}${BOLD}Some issues found ⚠${RESET} ($checks_passed passed, $checks_failed failed)"
    echo ""
    echo "${GRAY}Run ${WHITE}semver-ai init${GRAY} to fix missing configuration${RESET}"
fi

echo ""