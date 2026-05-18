# styles.sh
# Modern CLI styling library - Hacker/Dev aesthetic

# Colors (using tput for compatibility)
RED=$(tput setaf 1 2>/dev/null || echo "")
GREEN=$(tput setaf 2 2>/dev/null || echo "")
YELLOW=$(tput setaf 3 2>/dev/null || echo "")
BLUE=$(tput setaf 4 2>/dev/null || echo "")
MAGENTA=$(tput setaf 5 2>/dev/null || echo "")
CYAN=$(tput setaf 6 2>/dev/null || echo "")
WHITE=$(tput setaf 7 2>/dev/null || echo "")
GRAY=$(tput setaf 8 2>/dev/null || echo "")

# Bold
BOLD=$(tput bold 2>/dev/null || echo "")
DIM=$(tput dim 2>/dev/null || echo "")
RESET=$(tput sgr0 2>/dev/null || echo "")

# Icons
ICON_OK="✓"
ICON_ERR="✗"
ICON_WARN="⚠"
ICON_INFO="ℹ"
ICON_ARROW="→"
ICON_BULLET="•"
ICON_LOCK="🔒"
ICON_KEY="🔑"
ICON_GEAR="⚙"
ICON_ROCKET="🚀"
ICON_BOX="📦"
ICON_GIT="⌘"
ICON_AI="🤖"

# Print functions with style
print_header() {
    echo ""
    echo "${CYAN}${BOLD}▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${RESET}"
    echo "${CYAN}${BOLD}▌ $1${RESET}"
    echo "${CYAN}${BOLD}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${RESET}"
    echo ""
}

print_success() {
    echo "${GREEN}${ICON_OK} ${1}${RESET}"
}

print_error() {
    echo "${RED}${ICON_ERR} ${1}${RESET}" >&2
}

print_warning() {
    echo "${YELLOW}${ICON_WARN} ${1}${RESET}"
}

print_info() {
    echo "${CYAN}${ICON_INFO} ${1}${RESET}"
}

print_keyval() {
    printf "  ${GRAY}%s${RESET}  ${BOLD}%s${RESET}\n" "$1" "$2"
}

print_arrow() {
    echo "  ${MAGENTA}${ICON_ARROW}${RESET} $1"
}

print_step() {
    echo "${BLUE}[${1}]${RESET} $2"
}

print_bullet() {
    echo "    ${GRAY}${ICON_BULLET}${RESET} $1"
}

# Separator
print_divider() {
    echo "${GRAY}────────────────────────────────────────────────────────${RESET}"
}

# Compact inline status (for status command)
status_line() {
    local key="$1"
    local val="$2"
    local color="${3:-$WHITE}"
    printf "  ${GRAY}%${WIDTH}s${RESET}  ${color}%s${RESET}\n" "$key" "$val"
}