function error() {
    local red='\033[0;31m'
    local nocolor='\033[0m'
    local message="$1"
    echo -e "${red}Error: ${message}${nocolor}"
    exit 1
}
